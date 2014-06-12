RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
EventEmitter  = require('events').EventEmitter
Connector     = null
#### sparse.Collection
# > Wrapper for Mongoose or MongoDB Clients
class Connection extends EventEmitter
  constructor:(args, @opts={})->
    Connector = require if Util.getCapabilities().mongooseLoaded() and !@opts.forceNative then './MongooseConnection' else './NativeConnection'
    @__conn = new Connector args, @opts
    @__conn.once 'open',  (conn)=> 
      @emit 'open', @
      @opts.open? @
    @__conn.once 'close', (evt)=> 
      @handleClose evt
      @opts.close? evt
    @__conn.on 'error', (e)=>
      @emit 'error', "#{e}"
      @opts.error? evt
    @connect args if args?
    @
  handleClose:(evt)->
    @__conn = null
    @emit 'close'
  connect:(args)->
    @__conn.connect args
  getConnection:->
    @__conn.getConnection()
  getMongoDB:->
    @__conn.getMongoDB()
  getDatabaseName:->
    @__conn.getDatabaseName()
  isConnected:-> 
    @__conn.isConnected()
  getCollectionNames:(callback)->
    @__conn.getCollectionNames (e, names) => callback? e, names
  close:(callback)->
    @__conn.close (e,s)=>
      callback? e,s
module.exports = Connection
module.exports.RikkiTikkiAPI = RikkiTikkiAPI