mongodb      = require 'mongodb'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
DSN           = RikkiTikkiAPI.DSN
EventEmitter  = require('events').EventEmitter
#### sparse.Collection
# > Establshes Mongo DB with Mongoose
class NativeConnection extends EventEmitter
  constructor:(args)->
    if !(RikkiTikkiAPI.connection)
      @_client = mongodb.MongoClient
      @connect args if args?
  handleClose:(evt)->
    @emit 'close', evt
  connect:(args)->
    @__attemptConnection @__dsn = new DSN args
  __attemptConnection:(string)->
    try
      @_client.connect "#{string}", null, (e,conn)=>
        return @emit 'error', e.message if e?
        @__conn = conn
        @emit 'open'
    catch e
      return @emit e
    @emit 'connected', @__conn
  getConnection:->
    @__conn
  getMongoDB:->
    @getConnection().db
  getDatabaseName:->
    @getMongoDB().databaseName
  getCollectionNames:(callback)->
    @__conn.collectionNames null, (e,res) => callback? e, res
  isConnected:-> 
    @__conn?
  close:(callback)->
    if @isConnected()
      @__conn.disconnect (e)=>
        @__conn = null
        callback? e
module.exports = NativeConnection