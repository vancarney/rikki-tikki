{_}           = require 'underscore'
fs            = require 'fs'
path          = require 'path'
RikkiTikkiAPI = module.parent.exports
class SchemaManager extends Object
  constructor:->
    @__loader = new RikkiTikkiAPI.SchemaLoader
  createSchema:(name, tree:{})->
  alterSchema:(name, tree:{})->
    s = @fetchSchema name
    _.extend s, tree
  fetchSchema:(name)->
    @__loader.getSchema name
  saveSchema:->
    @__loader.save()
module.exports = SchemaManager