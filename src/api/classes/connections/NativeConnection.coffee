mongodb       = require 'mongodb'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
DSN           = RikkiTikkiAPI.DSN
EventEmitter  = require('events').EventEmitter
#### sparse.Collection
# > Establshes Mongo DB with Mongoose
class NativeConnection extends EventEmitter
  constructor:(args)->
    @_client = mongodb.MongoClient
    @connect args if args?
  handleClose:(evt)->
    @emit 'close', evt
  connect:(args)->
    @__attemptConnection @__dsn = new DSN args
  __attemptConnection:(string)->
    return if @__conn?
    try
      @_client.connect "#{string}", null, (e,conn)=>
        return @emit 'error', e if e?
        @__conn = conn
        @emit 'open', conn
    catch e
      return @emit 'error', e
    @emit 'connected', @__conn
  getConnection:->
    @__conn
  getMongoDB:->
    @getConnection()
  getDatabaseName:->
    @getMongoDB().databaseName
  getCollectionNames:(callback)->
    @__conn.collectionNames (e,res) => callback? e, res
  isConnected:-> 
    @__conn?
  close:(callback)->
    if @isConnected()
      @__conn.close (e)=>
        @__conn = null
        callback? e
module.exports = NativeConnection