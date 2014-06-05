{_}           = require 'underscore'
RikkiTikkiAPI = module.parent.exports
Util          = RikkiTikkiAPI.Util
SchemaTreeManager = require '../schema_tree/SchemaTreeManager'
class SchemaService extends RikkiTikkiAPI.base_classes.Singleton
  constructor:->
    RikkiTikkiAPI.getCollectionManitor()
    .on 'changed', (data)=>
      _.each _.keys( data ), (operation)=>
        _.each data[operation], (collection)=>
          @["collection#{Util.String.capitalize operation}"] collection.name
  collectionAdded:(name)->
    RikkiTikkiAPI.getCollectionManager().getCollection name, (e,col)=>
      return console.log e if e?
      col.getTree (e,tree)=>
        SchemaTreeManager.getInstance().createTree name, tree, (e)=>
          return console.log "could not create SchemaTree file for '#{name}'" if e?
          RikkiTikkiAPI.getSchemaManager().createSchema name, (e)=>
            return console.log "could not create Schema JS file for '#{name}'" if e?
  collectionRemoved:(name)->
    SchemaTreeManager.getInstance().destroyTree name, (e,done)=>
      console.log "could not destroy SchemaTree file for '#{name}'" if e?
    RikkiTikkiAPI.getSchemaManager().destroySchema name, (e)=>
      console.log "could not destroy Schema JS file for '#{name}'" if e?
  schemaAdded:(name)->
    console.log "added schema: #{name}"
  schemaRemoved:(name)->
    console.log "removed schema: #{name}"
SchemaService.getInstance = ->
  @__instance ?= new SchemaService
module.exports = SchemaService