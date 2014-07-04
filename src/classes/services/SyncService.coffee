{_}           = require 'underscore'
RikkiTikkiAPI = module.parent.exports
Util          = RikkiTikkiAPI.Util
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
SchemaTreeManager = require '../schema_tree/SchemaTreeManager'
class SyncService extends RikkiTikkiAPI.base_classes.Singleton
  constructor:->
    RikkiTikkiAPI.getCollectionManitor()
    .on 'changed', (data)=>
      _.each _.keys( data ), (operation)=>
        _.each data[operation], (collection)=>
          @["collection#{Util.String.capitalize operation}"] collection.name
  collectionAdded:(name)->
    # console.log "added collection: #{name}"
    RikkiTikkiAPI.getCollectionManager().getCollection name, (e,col)=>
      return console.log e if e?
      col.getTree (e,tree)=>
        SchemaTreeManager.getInstance().createTree name, tree, (e)=>
          return console.log "could not create SchemaTree file for '#{name}'\n\t#{e}" if e?
          RikkiTikkiAPI.getSchemaManager().createSchema name, (e)=>
            return console.log "could not create Schema JS file for '#{name}'\n\t#{e}" if e?
  collectionRemoved:(name)->
    "removed collection: #{name}"
    SchemaTreeManager.getInstance().destroyTree name, (e,done)=>
      console.log "could not destroy SchemaTree file for '#{name}'\n\t#{e}" if e?
    RikkiTikkiAPI.getSchemaManager().destroySchema name, (e)=>
      console.log "could not destroy Schema JS file for '#{name}'\n\t#{e}" if e?
  schemaAdded:(name)->
    # console.log "added schema: #{name}"
    SchemaTreeManager.getInstance().createTree name, tree, (e)=>
      return console.log "could not create SchemaTree file for '#{name}'\n\t#{e}" if e?
    # attempts to rename the Collection from the Database
    RikkiTikkiAPI.getCollectionManager().createCollection name, (e)=>
      console.log "could not create Collection '#{name}'\n\t#{e}" if e?
  schemaRemoved:(name)->
    # console.log "removed schema: #{name}"
    SchemaTreeManager.getInstance().destroyTree name, (e)=>
      console.log "could not destroy SchemaTree file for '#{name}'\n\t#{e}" if e?
    # attempts to rename the Collection from the Database
    RikkiTikkiAPI.getCollectionManager().destroyCollection name, (e)=>
      console.log "could not destroy Collection '#{name}'\n\t#{e}" if e?
module.exports = SyncService