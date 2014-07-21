RikkiTikkiAPI   = module.parent.exports.RikkiTikkiAPI
Util            = RikkiTikkiAPI.Util
Connection      = RikkiTikkiAPI.Connection
Collection      = require './Collection'
{_}             = require 'underscore'
class CollectionManager extends RikkiTikkiAPI.base_classes.Singleton
  __cache:{}
  constructor:->
    # errors and exits process if the DB connection is `null`
    unless (@__conn = RikkiTikkiAPI.getConnection())?
      throw 'Database is not connected'
      process.exit 1
    # errors and exits process if DB connection was `invalid`
    unless Util.Object.isOfType @__conn, Connection
      throw "Connection was invalid. Expected `RikkiTikkiAPI.Connection` type was '<#{typeof @__conn}>'"
      process.exit 1
    # errors and exits process if MongoDB reference is `null`
    unless (@__db = @__conn.getMongoDB())?
      throw Error 'MongoDB Connection is broken'
      process.exit 1
  createCollection:(name, opts, callback)->
    if typeof opts == 'function'
      callback ?= opts
      opts = {}
    Collection.create name, opts, (e,collection)=>
      return callback? e, null if e?
      @__cache[name] = collection
      callback? e, collection
  dropCollection:(name, callback)->
    @getCollection name, (e,collection)=>
      collection.drop (e, res)=>
        RikkiTikkiAPI.getCollectionMonitor().refresh()
        callback? e, collection
  listCollections:->
    c = RikkiTikkiAPI.getCollectionMonitor().getCollection()
    # console.log c
    c
  renameCollection:(oldName, newName, callback)->
    @getCollection oldName, (e,collection)=> 
      collection.rename newName, dropTarget:true, (e, res)=>
        RikkiTikkiAPI.getCollectionMonitor().refresh()
        callback? e, res
  getCollection:(name, callback)->
    # tests for existance of Collection name in Collection Cache
    if (collection = @__cache[name])? and collection instanceof Collection
      return callback? null, _.clone collection
    else
      # creates Collection existance in Monitor and adds it to Collection Cache
      if 0 <= (idx = RikkiTikkiAPI.getCollectionMonitor().getItemIdx(name))
        return callback? null, @__cache[name] = new Collection name
    # reports failure to find collection in cache
    callback? 'collection not found', null
module.exports = CollectionManager