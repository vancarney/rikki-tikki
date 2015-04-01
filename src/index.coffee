#### RikkiTikki API Class
#> requires: underscore
{_}             = require 'underscore'
#> requires: events
{EventEmitter}  = require 'events'
#> requires: fs
fs              = require 'fs'
#> requires: path
path            = require 'path'
# > Defines the `RikkiTikki` namespace in the 'global' environment
class RikkiTikkiAPI extends EventEmitter
  # holder for the Routing Adapter
  __adapter:null
  # holder for Auto-Detected Routing Adapter Type
  __detected_adapter: null
  # class constructor
  constructor:(__options=new RikkiTikkiAPI.APIOptions, callback)->
    # sets up an APIOptions object from passed params
    __options = new RikkiTikkiAPI.APIOptions __options unless RikkiTikkiAPI.Util.Object.isOfType __options, RikkiTikkiAPI.APIOptions
    return callback? 'required param `adapter` was undefined', false unless (adapter = __options.get 'adapter')
    useAdapter = (adapter, options)=>
      # checks for adapter passed from arguments
      if adapter
        # tests for adapter  param type
        if typeof adapter == 'string'
          # attempts to lookup adapter type if adapter param was string
          if 0 <= RikkiTikkiAPI.Adapters.listAdapters().indexOf adapter
            # defines `__adapter` with new Routing Adapter of type <adapter>
            @__adapter = new (RikkiTikkiAPI.Adapters.getAdapter adapter) options
          else
            # throws error if Routing Adapter was not found in lookup attempt
            throw "Routing Adapter '#{adapter}' was not registered. Use RikkiTikkiAPI.Adapters.registerAdapter(name, class)"
        else
          # sets adapter with Routing Adapter
          @__adapter = adapter
        # overwrites statis getAdapter method with defined routing adapter
        RikkiTikkiAPI.getAdapter = => @__adapter
        # tests for active DB Connection
        if RikkiTikkiAPI.getConnection()?
          # initializes routes if both `__adapter` and `router` are defined
          if @__adapter? and (router = new RikkiTikkiAPI.Router)?
            router.intializeRoutes()
            @emit 'ready'
        else
          # declares listener for open event
          @once 'open', =>
            # initialized routes if both `__adapter` and `router` are defined (Can we DRY this out?)
            if @__adapter? and (router = new RikkiTikkiAPI.Router)?
              router.intializeRoutes()
              @emit 'ready'
      else
        # throws error if adapter is not passed
        throw 'param \'adapter\' is required'
        process.exit 1
    # Attempts to load `db.json` in CONFIG_PATH
    (@__config = new RikkiTikkiAPI.ConfigLoader __options ).load (e, data)=>
      # returns and invokes callback if error is defined
      # return callback? e if e?
      # attempts to connect with `DSN` created for NODEJS.ENV from Config
      @connect (unless e? then @__config.getEnvironment RikkiTikkiAPI.Util.Env.getEnvironment() else host:'localhost'), {
        # defines open handler
        open: =>
          # attempts to use Routing Adapter if defined in APIOptions object
          useAdapter adapter if (adapter = __options.get 'adapter')?
          # retrieves instance of Schema Service to initiate it
          SyncService.getInstance() if RikkiTikkiAPI.Util.Env.isDevelopment()
          # emits open event with reference to `connection`
          @emit 'open', null, @__conn
        # defines error handler
        error: (e)=>
          # emits passed error event
          @emit 'error', e, null
        # defines close handler that emits close event
        close: => @emit 'close'
      }
    # invokes callback if defined
    callback? null, true
  ## connect(dsn, options)
  # > Manually create connection to Mongo Database Server
  connect:(dsn,opts)->
    # defines __conn with Connection
    @__conn = RikkiTikkiAPI.getConnection()
    # adds listener for open events
    @__conn.once 'open', (evt)=>
      # invokes open handler in options object if exists
      opts?.open? evt
    # adds listener for close event
    @__conn.once 'close', (evt) => opts?.close? evt
    # adds listener for error event
    @__conn.once 'error', (e)   => opts?.error? e
    # adds listener for connect event
    @__conn.connect dsn
  ## disconnect(dsn, options)
  # > Manually closes connection to Mongo Database Server
  disconnect:(callback)->
    @__conn.close (e,s)=>
      delete SchemaManager.__instance
      delete SchemaTreeManager.__instance
      delete CollectionManager.__instance
      delete SyncService.__instance
      delete @__conn
      callback? e,s

# exports the API
module.exports = RikkiTikkiAPI

#### Begin STATIC definitions

#### API Option Defaults
#> Debug: Toggles Debug Messages. Default: false
RikkiTikkiAPI.DEBUG               = false
#> Adapter: Defines which Routing Adapter to use. Default: null
RikkiTikkiAPI.ADAPTER             = null
#> DESTRUCTIVE: If enabled will destroy Schema Files and Collections. Default: false
RikkiTikkiAPI.DESTRUCTIVE         = false
#> API_BASEPATH: Base routing path for the API. Default: /api
RikkiTikkiAPI.API_BASEPATH        = '/api'
#> API_VERSION: Declarative version of the API appends to API_BASEPATH. Default: 1
RikkiTikkiAPI.API_VERSION         = '1'
RikkiTikkiAPI.API_NAMESPACE       = ''
RikkiTikkiAPI.AUTH_CONFIG_PATH    = "#{process.cwd()}#{path.sep}configs#{path.sep}auth"
#> CONFIG_PATH: Filesystem path to the Config File. Default: ./configs
RikkiTikkiAPI.CONFIG_PATH         = "#{process.cwd()}#{path.sep}configs"
#> CONFIG_FILENAME: Name for the Config File. Default: db.json
RikkiTikkiAPI.CONFIG_FILENAME     = 'db.json'
#> SCHEMA_PATH: Filesystem path to the Schema Files. Default: ./schemas
RikkiTikkiAPI.SCHEMA_PATH         = "#{process.cwd()}#{path.sep}schemas"
#> SCHEMA_API_REQUIRE_PATH: Filesystem path to the RikkiTikki API for Schema Files. Default: 'rikki-tikki'
RikkiTikkiAPI.SCHEMA_API_REQUIRE_PATH   = "rikki-tikki"
RikkiTikkiAPI.SCHEMA_TREES_FILE   = 'schema.json'
#> WRAP_SCHEMA_EXPORTS: Wrap Generated Schemas with a `model`. Default: true
RikkiTikkiAPI.WRAP_SCHEMA_EXPORTS = true

## Client Params
RikkiTikkiAPI.CLIENT_HOST                 = "0.0.0.0"
RikkiTikkiAPI.CLIENT_PORT                 = 80
RikkiTikkiAPI.CLIENT_API_VERSION          = RikkiTikkiAPI.API_VERSION
RikkiTikkiAPI.CLIENT_APP_ID               = null
RikkiTikkiAPI.CLIENT_APP_ID_PARAM_NAME    = null
RikkiTikkiAPI.CLIENT_API_NAMESPACE        = RikkiTikkiAPI.API_NAMESPACE
RikkiTikkiAPI.CLIENT_REST_KEY             = null
RikkiTikkiAPI.CLIENT_REST_KEY_PARAM_NAME  = null
RikkiTikkiAPI.CLIENT_PROTOCOL             = 'HTTP'

RikkiTikkiAPI.createAdapter = (name, opts)->
  (inst = AdapterManager.getInstance()).createAdapter.apply inst, arguments
RikkiTikkiAPI.getAdapterByName = (name)->
  (inst = AdapterManager.getInstance()).getAdapter.apply inst, arguments
RikkiTikkiAPI.listAdapters = ->
  AdapterManager.getInstance().listAdapters()
RikkiTikkiAPI.registerAdapter = (name, adapterClass)->
  (inst = AdapterManager.getInstance()).registerAdapter.apply inst, arguments
RikkiTikkiAPI.unregisterAdapter = (name)->
  (inst = AdapterManager.getInstance()).registerAdapter.apply inst, arguments
  
#### Static API Methods
RikkiTikkiAPI.getAdapter = -> null
## getConnection()
#> returns the current DB Connection
RikkiTikkiAPI.getConnection = ->
  RikkiTikkiAPI.Connection.getInstance()
RikkiTikkiAPI.isConnected = ->
  RikkiTikkiAPI.getConnection().isConnected()
## getAPIPath()
#> returns the Base REST path for the API Client
RikkiTikkiAPI.getAPIPath = ->
  "#{RikkiTikkiAPI.API_BASEPATH}/#{RikkiTikkiAPI.API_VERSION}"

RikkiTikkiAPI.addRoute = (path, operation, handler)=>
  if (_adapter = RikkiTikkiAPI.getAdapter())?
    _adapter.addRoute path, operation, handler
  else
    throw new Error 'Adapter is not defined'
## getSchemaManager(type,options)
#> Returns the SchemaManager instance
RikkiTikkiAPI.getSchemaManager = ->
  SchemaManager.getInstance()
## getSchemaTreeManager(type,options)
#> Returns the SchemaTreeManager instance
RikkiTikkiAPI.getSchemaTreeManager = ->
  SchemaTreeManager.getInstance()
## getCollectionMonitor()
#> Returns the SchemaMonitor instance
RikkiTikkiAPI.getSchemaMonitor = ->
  SchemaMonitor.getInstance()
## registerModule(name, class)
#> Registers a Module with the API
RikkiTikkiAPI.registerModule = (name, clazz)->
  ModuleManager.getInstance()?.registerModule name, clazz
## registerModule(name, class)
#> Registers a Module with the API
RikkiTikkiAPI.retrieveModule = (name)->
  ModuleManager.getInstance()?.retrieveModule name
## removeModule(name)
#> Removes a Module from the API
RikkiTikkiAPI.removeModule = (name)->
  ModuleManager.getInstance()?.removeModule name
## getCollectionManager()
#> Returns the CollectionManager instance
RikkiTikkiAPI.getCollectionManager = ->
  CollectionManager.getInstance()
## getCollectionMonitor()
#> Returns the CollectionMonitor instance
RikkiTikkiAPI.getCollectionMonitor = ->
  CollectionMonitor.getInstance()
## getSchemaTree(name)
#> retrieves SchemaTree if exists
RikkiTikkiAPI.getSchemaTree = (name)->
  if (tree = SchemaTreeManager.getInstance().__trees[name]) then tree else {}
RikkiTikkiAPI.getOptions = ->
  new RikkiTikkiAPI.APIOptions
## listCollections()
#> Returns list of all collection names currently in Database
RikkiTikkiAPI.listCollections = ->
  @getCollectionMonitor().getNames()
## RikkiTikkiAPI.extend(objects...)
#> Reference to Underscore's extend
RikkiTikkiAPI.extend = _.extend
## RikkiTikkiAPI.model(name,schema)
#> Model wrapper for Schemas
RikkiTikkiAPI.model = (name,schema={})->
  # throws error if name is not passed
  throw "name is required for model" if !name
  # throws error if name was not string
  throw "name expected to be String type was '#{type}'" if (type = typeof name) != 'string'
  _this = @
  # defined JS function that will be invoked with new constructor
  model = `function model(data, opts) { if (!(this instanceof RikkiTikkiAPI.model)) return _.extend(_this, new RikkiTikkiAPI.Document( data, opts )); }`
  # defines modelName attribute on Wrapper Function
  model.modelName = name
  # defines schema attribute on Wrapper Function
  model.schema    = schema
  # defines `toClientSchema` method on Wrapper Function
  model.toClientSchema = ->
    new RikkiTikkiAPI.ClientSchema @modelName, @schema
  # defines `toAPISchema` method on Wrapper Function
  model.toAPISchema = ->
    new RikkiTikkiAPI.APISchema @modelName, @schema
  model

#### Included Classes

try
  # puts the client lib into the cache
  require 'rikki-tikki-client'
catch e
  # throws error if client lib was not found
  throw new Error "rikki-tikki-client was not found. Try 'npm install rikki-tikki-client'"
  process.exit 1

RikkiTikkiAPI.Util              = require './classes/utils'
RikkiTikkiAPI.base_classes      = require './classes/base_class'
RikkiTikkiAPI.APIOptions        = require './classes/config/APIOptions'
_types                          = require './classes/types'
RikkiTikkiAPI.OperationTypes    = _types.OperationTypes
RikkiTikkiAPI.DSN               = require 'mongo-dsn'
ClientLoader                    = require './classes/client/ClientLoader'
_connections                    = require './classes/connections'
RikkiTikkiAPI.Connection        = _connections.Connection
_router                         = require './classes/router'
RikkiTikkiAPI.Router            = _router.Router
RikkiTikkiAPI.RoutingParams     = _router.RoutingParams
RikkiTikkiAPI.ConfigLoader      = require './classes/config/ConfigLoader'
RikkiTikkiAPI.Schema            = require './classes/schema/Schema'
RikkiTikkiAPI.APISchema         = require './classes/schema/APISchema'
RikkiTikkiAPI.ClientSchema      = require './classes/schema/ClientSchema'
AdapterManager                  = require './classes/request_adapters/AdapterManager'
ModuleManager                   = require './classes/modules/ModuleManager'
SchemaManager                   = require './classes/schema/SchemaManager'
SchemaMonitor                   = require './classes/schema/SchemaMonitor'
SchemaTree                      = require './classes/schema_tree/SchemaTree'
SchemaTreeManager               = require './classes/schema_tree/SchemaTreeManager'
SyncService                     = require './classes/services/SyncService'
_collections                    = require './classes/collections'
CollectionManager               = _collections.CollectionManager
CollectionMonitor               = _collections.CollectionMonitor
RikkiTikkiAPI.Collection        = _collections.Collection
RikkiTikkiAPI.Document          = _collections.Document
Model                           = _collections.Model
# create app dirs
cnf = new (require './classes/config/AppConfig')()
RikkiTikkiAPI.Util.File.ensureDirExists cnf.get 'data_path'
RikkiTikkiAPI.Util.File.ensureDirExists cnf.get 'trees_path'