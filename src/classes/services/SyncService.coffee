{_}                           = require 'underscore'
RikkiTikkiAPI                 = module.parent.exports
Util                          = RikkiTikkiAPI.Util
module.exports.RikkiTikkiAPI  = RikkiTikkiAPI
SyncOperation                 = require './SyncOperation'
SchemaTreeManager             = require '../schema_tree/SchemaTreeManager'
class SyncService extends RikkiTikkiAPI.base_classes.Singleton
  __opCache:[]
  getOpIndex:(name, type)->
    (_.map @__opCache, (v,k)-> "#{v.name}:#{v.operation}").indexOf "#{name}:#{type}"
  constructor:->
    @collectionManager = RikkiTikkiAPI.getCollectionManager()
    @schemaManager     = RikkiTikkiAPI.getSchemaManager()
    @schemaTreeManager = SchemaTreeManager.getInstance()
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
    RikkiTikkiAPI.getSchemaMonitor()
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
    RikkiTikkiAPI.getCollectionMonitor()
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
        return console.log e if e?
        col.getTree (e,tree)=>
          @schemaTreeManager.createTree name, tree, (e)=>
            return console.log "could not create SchemaTree file for '#{name}'\n\t#{e}" if e?
            @schemaManager.createSchema name, (e)=>
              return console.log "could not create Schema JS file for '#{name}'\n\t#{e}" if e?
    else
      @__opCache.splice idx, 1
  collectionRemoved:(name)->
    unless 0 <= (idx = @getOpIndex name, 'removed')
      @schemaTreeManager.destroyTree name, (e,done)=>
        console.log "could not destroy SchemaTree file for '#{name}'\n\t#{e}" if e?
      @schemaManager.destroySchema name, (e)=>
        console.log "could not destroy Schema JS file for '#{name}'\n\t#{e}" if e?
    else
      @__opCache.splice idx, 1
  collectionReplaced:(name)->
    console.log "replaced collection: #{name}"
  schemaAdded:(name, tree={})->
    unless 0 <= (idx = @getOpIndex name, 'added')
      @schemaTreeManager.createTree name, tree, (e)=>
        return console.log "could not create SchemaTree file for '#{name}'\n\t#{e}" if e?
        # attempts to rename the Collection from the Database
        @collectionManager.createCollection name, (e)=>
          console.log "could not create Collection '#{name}'\n\t#{e}" if e?
    else
      @__opCache.splice idx, 1
  schemaRemoved:(name)->
    unless 0 <= (idx = @getOpIndex name, 'removed')
      # console.log "removed schema: #{name}"
      @schemaTreeManager.destroyTree name, (e)=>
        console.log "could not destroy SchemaTree file for '#{name}'\n\t#{e}" if e?
        # attempts to remove the Collection from the Database
        @collectionManager.dropCollection name, (e)=>
          console.log "could not destroy Collection '#{name}'\n\t#{e}" if e?
    else
      @__opCache.splice idx, 1
  schemaReplaced:(name)->
    @schemaManager.reloadSchema name
module.exports = SyncService