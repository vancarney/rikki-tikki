{_}       = require 'lodash'
Util      = require '../utils'
Singleton = require '../base_class/Singleton'
class SyncService extends Singleton
  __opCache:[]
  getOpIndex:(name, type)->
    (_.map @__opCache, (v,k)-> "#{v.name}:#{v.operation}").indexOf "#{name}:#{type}"
  constructor:->
    @dsManager         = DataSourceManager.getInstance()
    @collectionManager = CollectionManager.getInstance()
    @schemaManager     = SchemaManager.getInstance()
    # @schemaTreeManager = new SchemaTreeManager ds
    _schemas        = []
    _collections    = []
    _schemaInit     = false
    _collectionInit = false
    _syncInit = =>
      _.each _schemas, (v,k)=>
        @collectionManager.getCollection v.name, (e,col)=>
          unless col?
            @__opCache.push new SyncOperation v.name, 'added'
            @collectionManager.createCollection v.name
      _.each _collections, (v,k)=>
        @schemaManager.getSchema v.name, (e,col)=>
          unless col?
            @__opCache.push new SyncOperation v.name, 'added'
            @schemaManager.createSchema v.name
    SchemaMonitor.getInstance()
    .on 'init', (data)=>
      _schemas = arguments['0'].added
      _syncInit() if ((_schemaInit = true) and _collectionInit)
    .on 'changed', (data)=>
      setTimeout (=>
        _.each _.keys( data ), (operation)=>
          _.each data[operation], (schema)=>
            @["schema#{Util.String.capitalize operation}"] schema.name
            @__opCache.push new SyncOperation schema.name, operation
      ), 500
    CollectionMonitor.getInstance()
    .on 'init', (data)=>
      _collections = arguments['0'].added
      _syncInit() if ((_collectionInit = true) and _schemaInit)
    .on 'changed', (data)=>
      setTimeout (=>
        _.each _.keys( data ), (operation)=>
          _.each data[operation], (collection)=>
            @["collection#{Util.String.capitalize operation}"] collection.name
            @__opCache.push new SyncOperation collection.name, operation
      ), 500
  collectionAdded:(name)->
    unless 0 <= (idx = @getOpIndex name, 'added')
      @collectionManager.getCollection name, (e,col)=>
        return logger.log e if e?
        col.getTree (e,tree)=>
          @schemaTreeManager.createTree name, tree, (e)=>
            return logger.log "could not create SchemaTree file for '#{name}'\n\t#{e}" if e?
            @schemaManager.createSchema name, (e)=>
              return logger.log "could not create Schema JS file for '#{name}'\n\t#{e}" if e?
    else
      @__opCache.splice idx, 1
  collectionRemoved:(name)->
    unless 0 <= (idx = @getOpIndex name, 'removed')
      @schemaTreeManager.destroyTree name, (e,done)=>
        logger.log "could not destroy SchemaTree file for '#{name}'\n\t#{e}" if e?
      @schemaManager.destroySchema name, (e)=>
        logger.log "could not destroy Schema JS file for '#{name}'\n\t#{e}" if e?
    else
      @__opCache.splice idx, 1
  collectionReplaced:(name)->
    logger.log "replaced collection: #{name}"
  schemaAdded:(name, tree={})->
    unless 0 <= (idx = @getOpIndex name, 'added')
      @schemaTreeManager.createTree name, tree, (e)=>
        return logger.log "could not create SchemaTree file for '#{name}'\n\t#{e}" if e?
        # attempts to rename the Collection from the Database
        @collectionManager.createCollection name, (e)=>
          logger.log "could not create Collection '#{name}'\n\t#{e}" if e?
    else
      @__opCache.splice idx, 1
  schemaRemoved:(name)->
    unless 0 <= (idx = @getOpIndex name, 'removed')
      # logger.log "removed schema: #{name}"
      @schemaTreeManager.destroyTree name, (e)=>
        logger.log "could not destroy SchemaTree file for '#{name}'\n\t#{e}" if e?
        # attempts to remove the Collection from the Database
        @collectionManager.dropCollection name, (e)=>
          logger.log "could not destroy Collection '#{name}'\n\t#{e}" if e?
    else
      @__opCache.splice idx, 1
  schemaReplaced:(name)->
    @schemaManager.reloadSchema name
module.exports = SyncService
SyncOperation     = require './SyncOperation'
DataSourceManager = require '../datasource/DataSourceManager'
CollectionManager = require '../collections/CollectionManager'
CollectionMonitor = require '../collections/CollectionMonitor'
SchemaManager     = require '../schema/SchemaManager'
SchemaMonitor     = require '../schema/SchemaMonitor'
SchemaTreeManager = require '../schema_tree/SchemaTreeManager'