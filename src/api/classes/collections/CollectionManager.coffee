RikkiTikkiAPI   = module.parent.exports.RikkiTikkiAPI
Util            = RikkiTikkiAPI.Util
Connection      = RikkiTikkiAPI.Connection
Collection      = module.parent.exports.Collection
{_}             = require 'underscore'
class CollectionManager extends RikkiTikkiAPI.base_classes.SingletonEmitter
  __cache:{}
  constructor:->
    throw 'database is not connected' if !(@__conn = RikkiTikkiAPI.getConnection())
    throw "Connection was invalid. Type was '#{typeof @__conn}'" if !Util.Object.isOfType @__conn, Connection
    @__db = @__conn.getMongoDB() || throw Error 'Connection is broken'
  createCollection:(name, opts, callback)->
    if typeof opts == 'function'
      callback ?= opts
      opts = {}
    @__db.createCollection name, opts, (e,collection)=>
      RikkiTikkiAPI.getCollectionManitor().refresh()
      callback? e, collection
  dropCollection:(name, callback)->
    @getCollection name, (e,collection)=>
      collection.drop (e, res)=>
        RikkiTikkiAPI.getCollectionManitor().refresh()
        callback? e, collection
  renameCollection:(oldName, newName, callback)->
    @getCollection oldName, (e,collection)=> 
      collection.rename newName, dropTarget:true, (e, res)=>
        RikkiTikkiAPI.getCollectionManitor().refresh()
        callback? e, res
  getCollection:(name, callback)->
    if (collection = @__cache[name])? and collection instanceof Collection
      callback? null, _.clone collection
    else
      try
        (col = new Collection name)?.getCollection (e,col)=>
          callback? e, if e? then null else @__cache[name] = col
      catch e
        callback? e, null
CollectionManager.getInstance = ->
  @__instance ?= new CollectionManager
module.exports = CollectionManager