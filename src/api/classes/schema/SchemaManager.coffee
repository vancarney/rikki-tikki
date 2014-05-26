{_}           = require 'underscore'
fs            = require 'fs'
path          = require 'path'
RikkiTikkiAPI = module.parent.exports
Util          = RikkiTikkiAPI.Util
Schema        = RikkiTikkiAPI.Schema
class SchemaManager extends Object
  constructor:->
    @__loader = new RikkiTikkiAPI.SchemaLoader
  createSchema:(name, tree)->
    if tree and !Util.isOfType tree, Object
      @__loader.addSchema new Schema tree
    else
      throw 'tree must be an object'
  alterSchema:(name, tree)->
    if tree and Util.isOfType tree, Object
      s.add tree if (s = @fetchSchema name)?
    else
      throw 'tree must be an object' 
  fetchSchema:(name)->
    if (schema = @__loader.getSchema name)?
      return schema
    else
      throw "schema #{name} was not found"
  saveSchemas:->
    @__loader.save()
SchemaManager.getInstance = ->
  @__instance ?= new SchemaManager()
module.exports = SchemaManager