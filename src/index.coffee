#### APiHero
#> Manages Schema Life Cycle
#> requires: lodash
#> author: van carney <carney.van@gmail.com>
#>
#> requires: lodash
{_}             = require 'lodash'
#> requires: events
{EventEmitter}  = require 'events'
#> requires: fs
fs              = require 'fs'
#> requires: path
path            = require 'path'
Util            = require './classes/utils'
APIOptions      = require './classes/config/APIOptions'
global.logger   = console
# > Defines the `ApiHero` Class
class ApiHero extends EventEmitter
  constructor:(app, options)->
    throw 'argument[0] must be App reference' unless app? and typeof app is 'function'
    # extends Loopback App with NoeJS EventEmitter
    _.extend app.prototype, EventEmitter
    # exports getApp helper method
    module.exports.getApp = => app
    # applies user options to API Options object
    _.each options, (v,k)=> APIOptions.set k,v
    # ensures existence of data dir path
    ApiHero.Util.File.ensureDirExists APIOptions.get 'data_path'
    # ensures existence of schema trees dir path
    ApiHero.Util.File.ensureDirExists APIOptions.get 'trees_path'
    # refences instance of Router
    @router = ApiHero.Router.getInstance()
    # adds route to GET JSON Schema
    @router.addRoute "/api-client/__schema__.json", 'get', (req,res)=>
      @router.getAdapter()?.responseHandler res,
        status:200
        content: ApiHero.SchemaManager.getInstance().toJSON Util.Env.isDevelopment()
    # adds route to GET JS Client
    @router.addRoute "/api-client/client(\.js)?", 'get', (req,res)=>
      @router.getAdapter()?.responseHandler res, (
        status:200
        content: @router.getClient()
      ), 'Content-Type':'text/javascript'
    # disables Loopback's LegacyExplorer UI 
    app.set 'legacyExplorer', false
    # sets reference of API Hero on Loopback App for convenience
    app.ApiHero = ApiHero
    # registers handler for 'ahero-initialized' event
    app.on 'ahero-initialized', =>
      SyncInitializer.init ApiHero unless Util.Env.isProduction()
    # initialize DataSource Manager instance
    ApiHero.DSManager.getInstance().initialize (e,ok)=>
      unless e?
        # emits 'ahero-initialized' event upon success
        return app.emit 'ahero-initialized'
      console.log e
# defines STATIC init method
ApiHero.init = (app, options)->
  new ApiHero app, options

#### Static API Methods

ApiHero.addRoute = (path, operation, handler)=>
  throw new Error 'Adapter is not defined' unless (router = ApiHero.Router.getInstance())?
  router.addRoute path, operation, handler

#### Included Classes
try
  # puts the client lib into the cache
  require 'rikki-tikki-client'
catch e
  # throws error if client lib was not found
  throw new Error "rikki-tikki-client was not found. Try 'npm install rikki-tikki-client'"
  process.exit 1
# applies Router classes as mix-in  
_.extend ApiHero, require './classes/router'
# sets Util classes onto main object
ApiHero.Util = require './classes/utils'
# ApiHero.SchemaManager = require './classes/schema/SchemaManager'
ApiHero.SyncService = require './classes/services/SyncService'
Document          = require './classes/collections/Document'
ApiHero.DSManager = require './classes/datasource/DataSourceManager'
# SyncInstance     = require './classes/services/SyncInstance'
SyncInitializer     = require './classes/services/SyncInitializer'
  
ApiHero.createSyncInstance = (name,clazz)=>
  ApiHero.SyncService.getInstance().registerSyncInstance name, new ApiHero.SyncService.SyncInstance name, clazz
ApiHero.destroySyncInstance = (name)=>
  ApiHero.SyncService.getInstance().removeSyncInstance name  
  

# ApiHero.APISchema       = require './classes/schema/APISchema'
# ApiHero.ClientSchema    = require './classes/schema/ClientSchema'
## ApiHero.model
#> Defines an insertable document reference
ApiHero.model = (name,schema={})->
  # throws error if name is not passed
  throw "name is required for model" if !name
  # throws error if name was not string
  throw "name expected to be String type was '#{type}'" if (type = typeof name) != 'string'
  _this = @
  # defined JS function that will be invoked with new constructor
  model = `function model(data, opts) { if (!(this instanceof ApiHero.model)) return _.extend(_this, new Document( data, opts )); }`
  # defines modelName attribute on Wrapper Function
  model.modelName = name
  # defines schema attribute on Wrapper Function
  model.schema    = schema
  # defines `toClientSchema` method on Wrapper Function
  model.toClientSchema = ->
    ClientSchema = require './classes/schema/ClientSchema'
    new ClientSchema @modelName, @schema
  # defines `toAPISchema` method on Wrapper Function
  model.toAPISchema = ->
    APISchema = require './classes/schema/APISchema'
    new APISchema @modelName, @schema
  model
# exports the API
module.exports = ApiHero