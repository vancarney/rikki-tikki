{_}           = require 'underscore'
fs            = require 'fs'
path          = require 'path'
RikkiTikkiAPI = module.parent.exports
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
SchemaLoader  = require './SchemaLoader'
class SchemaManager extends RikkiTikkiAPI.base_classes.Singleton
  @__schemas:{}
  constructor:->
    @__path = "#{RikkiTikkiAPI.getOptions().schema_path}"
    @load()
  load:->
    try
      # attempt to get stats on the file
      stat = fs.statSync @__path
    catch e
      throw new Error e
    if stat?.isDirectory()
      # walk this directory
      for file in fs.readdirSync @__path
        (@__schemas ?= {})[Util.File.name file] = new SchemaLoader "#{fs.realpathSync @__path}#{path.sep}#{file}"
  createSchema:(name, data={}, callback)->
    if !@__schemas[name]
      (@__schemas[name] = new SchemaLoader).create "#{@__path}#{path.sep}#{name}.js", data, callback
    else
      @getSchema name, callback
  getSchema:(name, callback)->  
    callback? null, if (schema = @__schemas[name])? then schema else null
  listSchemas:(callback)->
    callback? null, _.keys @__schemas
  saveSchema:(name, callback)->
    schema.save callback if (schema = @__schemas[name])?
  saveAll:(callback)->
    eOut = []
    _.each @__schemas, (v,k)-> 
      v.save (e)=> eOut.push e if e
    callback? if eOut.length  then eOut else null
  destroySchema:(name, callback)->
    schema.destroy callback if (schema = @__schemas[name])?
  toJSON:(readable)->
    JSON.parse @toString readable
  toString:(readable)->
    JSON.stringify {__meta__:@__meta, __schemas__:@__schemas}, SchemaLoader.replacer, if readable then 2 else undefined
SchemaManager.getInstance = ->
  @__instance ?= new SchemaManager()
module.exports = SchemaManager