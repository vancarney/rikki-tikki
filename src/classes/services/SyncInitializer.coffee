DataSourceManager = require '../datasource/DataSourceManager'
CollectionManager = require '../collections/CollectionManager'
CollectionMonitor = require '../collections/CollectionMonitor'
SchemaManager     = require '../schema/SchemaManager'
SchemaMonitor     = require '../schema/SchemaMonitor'
SchemaTreeManager = require '../schema_tree/SchemaTreeManager'

module.exports.init = (ApiHero)->
  # initialized sync instance for SchemaMonitor
  ApiHero.createSyncInstance 'schema', SchemaMonitor 
  .addSyncHandler 'schema', 'added', (op)=>
    tree = {}
    # attempts to rename the Collection from the Database
    CollectionManager.getInstance().createCollection op.name, (e, collection)=>
      return logger.log "could not create Collection '#{op.name}'\n\t#{e}" if e?
      collection.getTree (e,tree)=>
        SchemaTreeManager.getInstance().createTree op.name, tree, (e)=>
          return logger.log "could not create SchemaTree file for '#{op.name}'\n\t#{e}" if e?
  .addSyncHandler 'schema', 'replaced', (op)=>
    console.log 'schema replaced'
    SchemaManager.getInstance().reloadSchema op.data.name
  .addSyncHandler 'schema', 'removed', (op)=>
    console.log op
    SchemaTreeManager.getInstance().destroyTree op.data.name, (e)=>
      logger.log "could not destroy SchemaTree file for '#{name}'\n\t#{e}" if e?
      # attempts to remove the Collection from the Database
      CollectionManager.getInstance().dropCollection op.data.name, (e)=>
        logger.log "could not destroy Collection '#{name}'\n\t#{e}" if e?
  # initialized sync instance for CollectionMonitor
  ApiHero.createSyncInstance 'collection', CollectionMonitor
  .addSyncHandler 'collection', 'added', (collection)=>
      SchemaManager.getInstance().createSchema collection.name, (e)=>
        return logger.log "could not create Schema JS file for '#{collection.name}'\n\t#{e}" if e?
        # SchemaTreeManager.getInstance().createTree collection.name, tree, (e)=>
          # return logger.log "could not create SchemaTree file for '#{collection.name}'\n\t#{e}" if e?
  .addSyncHandler 'collection', 'replaced', (collection)=>
    console.log 'collection replaced'
    console.log arguments
    # SchemaManager.getInstance().renameSchema collection.name, (e)=>
      # logger.log "could not destroy Schema JS file for '#{collection.name}'\n\t#{e}" if e?
  .addSyncHandler 'collection', 'removed', (collection)=>
    # console.log "collection removed: #{collection.__renamedFrom}"
    # console.log CollectionMonitor.getInstance().getNames()
    SchemaManager.getInstance().destroySchema collection.name, (e)=>
      logger.log "could not destroy Schema JS file for '#{collection.name}'\n\t#{e}" if e?
      return
      SchemaTreeManager.destroyTree name, (e)=>
        logger.log "could not destroy SchemaTree file for '#{collection.name}'\n\t#{e}" if e?