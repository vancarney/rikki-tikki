{_}               = require 'lodash'
{EventEmitter}    = require 'events'
# SyncService       = require '../services/SyncService'
CollectionManager = require '../collections/CollectionManager'
class DataSource extends EventEmitter
  constructor:(name, ds)->
    _.extend @, _.clone ds
    @sourceName = name
    if typeof ds.buildModelFromInstance is 'function'
      @canBuildModelFromInstance = -> 
        true
      @buildModelFromInstance = (name, json, options, callback)=>
        throw 'callback is required as arguments[3]' unless callback? and typeof callback is 'function'
        m = ds.buildModelFromInstance.apply @, _.initial arguments
        callback.apply @, if m? then [null, m] else ['could not build model']
    @isRelational = ->
      @connector.relational || false
    @isNoSQL = ->
      @connector.nosql || (@name.match /^(mongodb|Memory)+$/)? || false
  buildModelFromInstance:(name, json, options)->
    throw 'dynamic collection creation not supported by this adapter'
  canBuildModelFromInstance:->
    false
  getDAO:->
    @connector.dataSource.DataAccessObject
  connected:->
    @connector.connected
  connect:(callback)->
    return throw 'callback required as arguments[0]' unless typeof arguments[0] is 'function'
    return @connect.apply @, arguments unless @connected()
    callback? null, @
  listCollections:->
    _.keys @models
    # @adapter.db.collections (e,res)->
      # return callback? e, null if e?
      # callback? null, _.compact _.map _.values(res), (v)->
        # if (v.s.name.match /\.+/)? then null else name:v.s.name
    # @collections.listCollections (e,data)->
      # return callback? e, null if e
      # callback? null, _.compact _.map data, (col)->
        # unless 0 <= col.s.name.indexOf '.' then col.s.name else null
   createCollection:(name, json, opts)->
     @modelBuilder.on 'initialize', => console.log 'initialized model'
     console.log (@createModel.apply @, arguments).definition.rawProperties
     
   buildCollection:(name, json, opts)->
     if typeof opts is 'function'
       callback = arguments[2]
       opts = {}
     @modelBuilder.on 'initialize', => console.log 'initialized model'
     throw "cannot create collections on SQL connection" unless @canBuildModelFromInstance()
     throw 'could not create collection' unless typeof (o = @buildModelFromInstance.apply @, arguments) is 'object'
     o
     
   getCollection:(name)->
     console.log @models
   removeCollection:(name)->
module.exports = DataSource