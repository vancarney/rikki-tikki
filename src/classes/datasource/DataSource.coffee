{_}               = require 'lodash'
{EventEmitter}    = require 'events'
# SyncService       = require '../services/SyncService'
APIOptions        = require '../config/APIOptions'
CollectionManager = require '../collections/CollectionManager'
class DataSource extends EventEmitter
  constructor:(name, ds)->
    _.extend @, ds
    @sourceName = name
    if typeof ds.buildModelFromInstance is 'function'
      @canBuildModelFromInstance = -> 
        true
      @buildModelFromInstance = ds.buildModelFromInstance #(name, json, options)=>
        # ds.buildModelFromInstance.apply @, arguments
    @isRelational = ->
      @connector.relational || false
    @isNoSQL = ->
      @connector.nosql || (@name.match /^(mongodb|Memory)+$/)? || false
    @connected = ->
      @connector.connected
    @connect = (callback)->
      console.log 'connect'
      return throw 'callback required as arguments[0]' unless typeof arguments[0] is 'function'
      return @connector.connect.apply @, arguments unless @connected()
  buildModelFromInstance:(name, json, options)->
    throw 'dynamic collection creation not supported by this adapter'
  canBuildModelFromInstance:->
    false
  getDAO:->
    @connector.dataSource.DataAccessObject

    callback? "unable to connect to DataSource: #{@sourceName}", @
  listModels:->
    builtins = [ 'Model',
      'PersistedModel',
      'Email',
      'Application',
      'AnonymousModel_0',
      'AnonymousModel_1',
      'AnonymousModel_2',
      'AnonymousModel_3',
      'AnonymousModel_4',
      'AnonymousModel_5',
      'AccessToken',
      'RoleMapping',
      'Role',
      'ACL',
      'Scope',
      'User',
      'Change',
      'Checkpoint' ]
    l = _.filter @models, (model, name)=>
      (0 > builtins.indexOf name) and (model != undefined) and (model.getDataSource()?.settings.name == @sourceName)
    _.compact _.map l, (m)-> m.definition.name
  listCollections:->
    []
    # console.log @ #connector.db.collectionNames
    # @adapter.db.collections (e,res)->
      # return callback? e, null if e?
      # callback? null, _.compact _.map _.values(res), (v)->
        # if (v.s.name.match /\.+/)? then null else name:v.s.name
    # @collections.listCollections (e,data)->
      # return callback? e, null if e
      # callback? null, _.compact _.map data, (col)->
        # unless 0 <= col.s.name.indexOf '.' then col.s.name else null
   createCollection:(name, json, opts)->
     # @modelBuilder.on 'initialize', => console.log 'initialized model'
     @createModel.apply @, arguments #).definition.rawProperties
     
   buildCollection:(name, json, opts)->
     if typeof opts is 'function'
       callback = arguments[2]
       opts = {}
     @modelBuilder.on 'initialize', => console.log 'initialized model'
     throw "cannot create collections on SQL connection" unless @canBuildModelFromInstance()
     throw 'could not create model' unless typeof (o = @buildModelFromInstance.apply @, arguments) is 'function'
     o
     
   getCollection:(name)->
     console.log @models
   removeCollection:(name)->
DataSource.getDataSource = (name)=>
  DataSourceManager = require './DataSourceManager'
  DataSourceManager.getInstance().getDataSource name
module.exports = DataSource