{_}           = require 'underscore'
fs            = require 'fs'
path          = require 'path'
RikkiTikkiAPI = module.parent.exports
Util          = RikkiTikkiAPI.Util
class SchemaService extends RikkiTikkiAPI.base_classes.Singleton
  constructor:->
    RikkiTikkiAPI.getCollectionManitor()
    .on 'changed', (data)=>
      _.each _.keys( data ), (operation)=>
        _.each data[operation], (collection)=>
          console.log collection
          @["collection#{Util.String.capitalize operation}"] collection
  collectionAdded:(name)->
    console.log "added collection: #{name}"
  collectionRemoved:(name)->
    console.log "removed collection: #{name}"
  schemaAdded:(name)->
    console.log "added schema: #{name}"
  schemaRemoved:(name)->
    console.log "removed schema: #{name}"
SchemaService.getInstance = ->
  @__instance ?= new SchemaService
module.exports = SchemaService