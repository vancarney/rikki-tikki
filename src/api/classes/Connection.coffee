mongoose = require 'mongoose'
EventEmitter = require('events').EventEmitter;
#### sparse.Collection
# > Establshes Mongo DB with Mongoose
class RikkiTikkiAPI.Connection extends EventEmitter
  constructor:(args)->
    if !(RikkiTikkiAPI.__connection)
      RikkiTikkiAPI.connection = mongoose.connection
      RikkiTikkiAPI.connection.on 'error', (e) => @emit 'error', e.message
      RikkiTikkiAPI.connection.on 'open', => @emit 'open', @getConnection()
    @connect args if args?
  handleClose:(evt)->
    @emit 'close', evt
  connect:(args)->
    @__attemptConnection @__dsn = new RikkiTikkiAPI.DSN args
  __attemptConnection:(string)->
    try
      @__conn = mongoose.connect "#{string}"
    catch e
      # console.log e.message
      # @emit 'error', 'failed to connect'
      return false
    @emit 'connected', @__conn
  getConnection:-> 
    @__conn || null
  getMongoDB:->
    mongoose.connection.db
  isConnected:-> 
    @__conn?
  close:(callback)->
    if @isConnected()
      @__conn.disconnect (e)=>
        @__conn = null
        # @emit 'close'
        callback? e