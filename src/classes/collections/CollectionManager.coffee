{_}               = require 'lodash'
Util              = require '../utils'
Singleton         = require '../base_class/Singleton'
class CollectionManager extends Singleton
  __cache:{}
  constructor:->
    @__ds = DSManager.getInstance()
    # collectionMonitor = new CollectionMonitor ds
    @refresh = =>
      # collectionMonitor.refresh()
  createCollection:(name, ds, json, opts, callback)->
    if typeof opts == 'function'
      callback ?= opts
      opts = {}
    Collection.create name, ds, json, opts, (e,collection)=>
      return callback? e, null if e?
      @__cache[name] = if collection instanceof Collection then collection else new Collection name
      @refresh()
      callback? e, collection
  dropCollection:(name, callback)->
    @getCollection name, (e,collection)=>
      return callback? e if e?
      return callback? 'collection undefined' unless collection?
      collection.drop (e, res)=>
        @refresh()
        callback? e, collection
  listCollections:(callback)->
    _.uniq _.flatten _.map @__ds.getDSNames(), (name)=> @__ds.getDataSource( name ).listCollections()
  renameCollection:(oldName, newName, callback)->
    @getCollection oldName, (e,collection)=> 
      collection.rename newName, dropTarget:true, (e, res)=>
        @refresh()
        callback? e, res
  getCollection:(name, callback)->
    # tests for existence of Collection name in Collection Cache
    if (collection = @__cache[name])? and collection instanceof Collection
      return callback? null, collection
    else
      cm = CollectionMonitor.getInstance()
      # checks for Collection existence in Monitor and adds it to Collection Cache
      if 0 <= (idx = cm.__collection.getItemIndex name)
        return callback? null, (@__cache[name] = new Collection name).getCollection()
    # reports failure to find collection in cache
    callback? 'collection not found', null
module.exports = CollectionManager
Collection        = require './Collection'
CollectionMonitor = require './CollectionMonitor'
DSManager         = require '../datasource/DataSourceManager'