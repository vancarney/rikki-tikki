RikkiTikkiAPI   = module.parent.exports.RikkiTikkiAPI
Util            = RikkiTikkiAPI.Util
Connection      = RikkiTikkiAPI.Connection
Collection      = require './Collection'
{_}             = require 'underscore'
class CollectionManager extends RikkiTikkiAPI.base_classes.Singleton
  __cache:{}
  constructor:->
    throw 'database is not connected' if !(@__conn = RikkiTikkiAPI.getConnection())
    throw "Connection was invalid. Type was '#{typeof @__conn}'" if !Util.Object.isOfType @__conn, Connection
    @__db = @__conn.getMongoDB() || throw Error 'Connection is broken'
  createCollection:(name, opts, callback)->
    if typeof opts == 'function'
      callback ?= opts
      opts = {}
    Collection.create name, opts, (e,collection)=>
      return callback? e, null if e?
      console.log "collection: #{JSON.stringify collection}"
      @__cache[name] = collection
      # RikkiTikkiAPI.getCollectionManitor().refresh()
      callback? e, collection
  dropCollection:(name, callback)->
    @getCollection name, (e,collection)=>
      collection.drop (e, res)=>
        RikkiTikkiAPI.getCollectionManitor().refresh()
        callback? e, collection
  listCollections:->
    c = RikkiTikkiAPI.getCollectionManitor().getCollection()
    # console.log c
    c
  renameCollection:(oldName, newName, callback)->
    @getCollection oldName, (e,collection)=> 
      collection.rename newName, dropTarget:true, (e, res)=>
        RikkiTikkiAPI.getCollectionManitor().refresh()
        callback? e, res
  getCollection:(name, callback)->
    if (collection = @__cache[name])? and collection instanceof Collection
      callback? null, _.clone collection
    else
      callback? null, null
      # @createCollection name, callback
      # try
        # if (col = new Collection name)?
          # RikkiTikkiAPI.getCollectionManitor().refresh()
          # callback? e, if e? then null else @__cache[name] = col
      # catch e
        # callback? e, null
module.exports = CollectionManager