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
global.helpers  = {}

# > Defines the `ApiHero` Class
class ApiHero extends EventEmitter
  constructor:(app, options)->
    throw 'argument[0] must be App reference' unless app? and typeof app is 'function'
    global.app_root ?= process.cwd()
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
    shouldManageRoutes = =>
      return options.monitor_requests if options?.hasOwnProperty 'monitor_requests' 
      return true unless Util.Env.isProduction()
    # registers handler for 'ahero-initialized' event
    app.once 'ahero-initialized', =>
      SyncInitializer.init ApiHero if shouldManageRoutes()
    # initialize DataSource Manager instance
    ApiHero.DSManager.getInstance().initialize (e,ok)=>
      if e?
        console.log e
        process.exit 1
      moduleManager = new ModuleManager app
      # virtualizes listModules
      app.ApiHero.listModules = => moduleManager.listModules()
      # virtualizes getModuleConfigs
      app.ApiHero.getModuleConfigs = => moduleManager.getModuleConfigs()
      # virtualizes getModule
      app.ApiHero.getModule = (name)=> moduleManager.getModule name
      app.emit 'ahero-initialized'
      moduleManager.load (e,modules)=>
        if e?
          throw e
          process.exit 1
        app.emit 'ahero-ready'
        # loadHelpers (e)=>
          # if e?
            # console.log e
            # process.exit 1
          # # emits 'ahero-initialized' event upon success
          # app.emit 'ahero-initialized'

# defines STATIC init method
ApiHero.init = (app, options)->
  new ApiHero app, options
ApiHero.loadedModules = null
#### Static API Methods


ApiHero.proxyEvent = (name, delegator)->
  throw "ApiHero.proxyEvent: delegator not defined" unless delegator
  throw "ApiHero.proxyEvent: delegator.on is not a function" unless typeof delegator.on is 'function'
  delegator.on? name, (evt,data)=> 
    module.exports.getApp().emit name, evt, data

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
ApiHero.SyncService   = require './classes/services/SyncService'
ApiHero.SyncInstance  = require './classes/services/SyncInstance'
ApiHero.SyncOperation = require './classes/services/SyncOperation'
Document          = require './classes/collections/Document'
ApiHero.DSManager = require './classes/datasource/DataSourceManager'
# SyncInstance     = require './classes/services/SyncInstance'
SyncInitializer     = require './classes/services/SyncInitializer'
# requires Module Manager
ModuleManager = require './classes/module/ModuleManager'
  
ApiHero.AbstractMonitor = require './classes/base_class/AbstractMonitor'
ApiHero.AbstractLoader  = require './classes/base_class/AbstractLoader'
  
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