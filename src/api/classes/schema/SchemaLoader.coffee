{_}           = require 'underscore'
fs            = require 'fs'
path          = require 'path'
RikkiTikkiAPI = module.parent.exports
Util          = RikkiTikkiAPI.Util
class SchemaLoader extends Object
  __schema:{}
  constructor:(@__path=RikkiTikkiAPI.SCHEMA_PATH)->
    @load() if @__path?
  load:->
    o = {}
    throw "No load path defined" if !@__path
    loadFile = (p,o={})->
      try
        # attempt to get stats on the file
        stat = fs.statSync p
      catch e
        throw new Error e
        return false
      if stat?.isDirectory()
        # walk this directory
        for file in fs.readdirSync p
          o = loadFile "#{fs.realpathSync p}#{path.sep}#{file}", o
      else
        try
          parseObj = (res,o)->
            switch (typeof res)
              when 'object'
                if (className = RikkiTikkiAPI.Util.getConstructorName res)? && className != 'Object'
                  o[path.basename p, '.js','.json'] = res
                else
                  _.each _.keys(res), (name) => 
                    o[name] = itm if (itm = parseObj res[name], o)?
              when 'function'
                if (fName = RikkiTikkiAPI.Util.getFunctionName res) == 'model'
                  o[res.modelName] = res
                  # Apply toClientSchema on Mongoose Model
                  if !(o[res.modelName].hasOwnProperty 'toClientSchema')
                    o[res.modelName].toClientSchema = -> 
                        RikkiTikkiAPI.model( @modelName, @schema ).toClientSchema()
            o
          res = require( "#{p}" )
          o = parseObj res, o
        catch e
          throw e
      o
    if @__path instanceof Object
      # tests if is Array
      if @__path instanceof Array
        # handles Array
        _.each @__path, (v,k)=>
          @__schema = loadFile v, @__schema
      else
        # handles Hash
        _.each _keys(@__path), (key)=>
          @__schema[key] = loadFile @__path[key], @__schema
    else
      # handles String
      try 
        @__schema = loadFile @__path
      catch e
        throw e
  save:->
    # fs.writeFile "#{RikkiTikkiAPI.SCHEMA_PATH}/rikkitikki/schema.js", s, (e)-> console.error 'failed to save schema' 
  getSchema:(name)->
    @__schema[name] || null 
  toJSON:->
    @__schema
  toString:(readable)->
    JSON.stringify @__schema, SchemaLoader.replacer, if readable then 2 else undefined
SchemaLoader.replacer = (key,value)->
  value = value.toClientSchema() if value?.toClientSchema?
  return if value? and (0 >= _.keys(RikkiTikkiAPI.Schema.reserved).indexOf key) then Util.Function.toString value else undefined
module.exports = SchemaLoader