{_}           = require 'underscore'
fs            = require 'fs'
path          = require 'path'
RikkiTikkiAPI = module.parent.exports
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
                o[res.modelName] = res if (fName = RikkiTikkiAPI.Util.getFunctionName res) == 'model'
            o
          res = require( "#{p}" )
          o = parseObj res, o
        catch
          throw new Error e
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
  toJSON:->
    @__schema
  toString:->
    JSON.stringify @toJSON(), null, 2 
module.exports = SchemaLoader