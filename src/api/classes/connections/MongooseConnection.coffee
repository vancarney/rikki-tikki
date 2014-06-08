mongoose      = require 'mongoose'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
DSN           = RikkiTikkiAPI.DSN
EventEmitter  = require('events').EventEmitter
#### sparse.Collection
# > Establshes Mongo DB with Mongoose
class MongooseConnection extends EventEmitter
  constructor:(args)->
    if !(@__conn = RikkiTikkiAPI.getConnection())
      client = mongoose.connection
      client.on 'error', (e) => @emit 'error', e.message
      client.on 'open', (conn)=> @emit 'open', conn
      @connect args if args?
  handleClose:(evt)->
    @emit 'close', evt
  connect:(args)->
    @__attemptConnection @__dsn = new DSN args
  __attemptConnection:(string)->
    try
      @__conn = mongoose.connect "#{string}"
    catch e
      return @emit e
    @emit 'connected', @__conn
  getConnection:->
    @__conn.connections[0]
  getMongoDB:->
    @getConnection().db
  getDatabaseName:->
    @getMongoDB().databaseName
  getCollectionNames:(callback)->
    @getMongoDB().collectionNames (e,res) => callback? e, res
  isConnected:-> 
    @__conn?
  close:(callback)->
    if @isConnected()
      @__conn.disconnect (e)=>
        @__conn = null
        # @emit 'close'
        callback? e
module.exports = MongooseConnection