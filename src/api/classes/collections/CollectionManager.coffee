RikkiTikkiAPI   = module.parent.exports.RikkiTikkiAPI
Util            = RikkiTikkiAPI.Util
Connection      = RikkiTikkiAPI.Connection
Collection      = module.parent.exports.Collection
{_}             = require 'underscore'
{EventEmitter}  = require 'events'
class CollectionManager extends EventEmitter
  __cache:{}
  constructor:(@__conn)->
    throw Error 'CollectionManager requires a Connection as arg1' if !@__conn
    throw Error "CollectionManager arg1 must be Connection. Type was '#{typeof @__conn}'" if !Util.isOfType @__conn, Connection
    @__db = @__conn.getMongoDB() || throw Error 'Connection is broken'
  createCollection:(name, opts, callback)->
    if typeof opts == 'function'
      callback ?= opts
      opts = {}
    @__db.createCollection name, opts, (e,collection)=>
      RikkiTikkiAPI.collectionMon.refresh()
      callback? e, collection
  dropCollection:(name, callback)->
    @getCollection name, (e,collection)=>
      collection.drop (e, res)=>
        RikkiTikkiAPI.collectionMon.refresh()
        callback? e, collection
  renameCollection:(oldName, newName, callback)->
    @getCollection oldName, (e,collection)=> 
      collection.rename newName, dropTarget:true, (e, res)=>
        RikkiTikkiAPI.collectionMon.refresh()
        callback? e, res
  getCollection:(name, callback)->
    if (collection = @__cache[name])? and collection instanceof Collection
      callback? null, _.clone collection
    else
      @__db.collection name, (e,collection)=>
        collection = _.clone( @__cache[name] = new Collection collection ) if collection
        callback? e, collection
CollectionManager.getInstance = ->
  throw 'database is not connected' if !(conn = RikkiTikkiAPI.getConnection())
  @__instance ?= new CollectionManager conn
module.exports = CollectionManager