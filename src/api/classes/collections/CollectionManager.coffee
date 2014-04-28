RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
Connection    = RikkiTikkiAPI.Connection
{EventEmitter}  = require 'events'
class CollectionManager extends EventEmitter
  constructor:(@__conn)->
    throw Error 'CollectionManager requires a Connection as arg1' if !@__conn
    throw Error "CollectionManager arg1 must be Connection. Type was '#{typeof @__conn}'" if !Util.isOfType @__conn, Connection
    @__db = @__conn.getMongoDB() || throw Error 'Connection is broken'
  createCollection:(name, opts, callback)->
    callback ?= opts if typeof opts == 'function'
    @__db.createCollection name, opts, (e,collection)=>
      callback? e, collection
  dropCollection:(name, callback)->
    @getCollection name, (e,collection)=>
      collection.drop (e, res)=>
        callback? e, collection
  renameCollection:(oldName, newName, callback)->
    @getCollection oldName, (e,collection)=> 
      collection.rename newName, dropTarget:true, (e, res)=> 
        callback? e, res
  getCollection:(name, callback)->
    @__db.collection name, (e,collection)=> callback? e, collection
module.exports = CollectionManager