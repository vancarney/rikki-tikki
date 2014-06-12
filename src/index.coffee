#### RikkiTikki API Class
#> requires: underscore
{_}             = require 'underscore'
#> requires: events
{EventEmitter}  = require 'events'
#> requires: path
path            = require 'path'
#> requires: js-arraycollection
ArrayCollection = require('js-arraycollection').ArrayCollection

# > Defines the `RikkiTikki` namespace in the 'global' environment
class RikkiTikkiAPI extends EventEmitter
  # holder for the Routing Adapter
  __adapter:null
  # holder for Auto-Detected Routing Adapter Type
  __detected_adapter: null
  # class constructor
  constructor:(__options=new RikkiTikkiAPI.APIOptions, callback)->
    # sets up an APIOptions object from passed params
    __options = new RikkiTikkiAPI.APIOptions __options if !(RikkiTikkiAPI.Util.Object.isOfType __options, RikkiTikkiAPI.APIOptions)
    # loops through list of Application Adapters
    for name in ['express'] #for name in ['express','hapi']
      # attempts to auto-detect default Connect Services
      if RikkiTikkiAPI.Util.detectModule name
        # sets `__detected_adapter` if not set
        @__detected_adapter ?= name
        # ends loop
        break
    # defines `RikkiTikkiAPI.getSchemas`
    RikkiTikkiAPI.getSchemas    = => RikkiTikkiAPI.SchemaManager.getInstance()
    # defines `RikkiTikkiAPI.useAdapter`
    RikkiTikkiAPI.useAdapter    = (adapter, options)=>
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
          # tests if <adapter> is instanceof `AbstractAdapter`
          if adapter instanceof RikkiTikkiAPI.base_classes.AbstractAdapter
            # sets adapter with Routing Adapter
            @__adapter = adapter
          else
            # throws error if Adapter was not a sub-class of `AbstractAdapter`
            throw "Routing Adapter must inherit from 'RikkiTikkiAPI.base_classes.AbstractAdapter'"
        # tests for active DB Connection
        if RikkiTikkiAPI.getConnection()?
          # initializes routes if both `__adapter` and `router` are defined
          router.intializeRoutes() if @__adapter? and (router = new RikkiTikkiAPI.Router)?
        else
          # declares listener for open event
          @once 'open', =>
            # initialized routes if both `__adapter` and `router` are defined (Can we DRY this out?)
            if @__adapter? and (router = new RikkiTikkiAPI.Router)?
              router.intializeRoutes()
      else
        # throws error if adapter is not passed
        throw 'param \'adapter\' is required'
    # defines `RikkiTikkiAPI.getAdapter`
    RikkiTikkiAPI.getAdapter    = => @__adapter
    #  Invokes `RikkiTikkiAPI.useAdapter` if adapter is defined
    RikkiTikkiAPI.useAdapter adapter if (adapter = __options.get 'adapter')?
    # Attempts to load `db.json` in CONFIG_PATH
    (@__config = new RikkiTikkiAPI.ConfigLoader __options ).load (e, data)=>
      # returns and invokes callback if error is defined
      return callback? e if e?
      # attempts to connect with `DSN` created for NODEJS.ENV from Config
      @connect (@__config.getEnvironment RikkiTikkiAPI.Util.Env.getEnvironment()), {
        # defines open handler
        open: =>
          # attempts to use Routing Adapter if defined in APIOptions object
          RikkiTikkiAPI.useAdapter __options.adapter if __options.adapter?
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
    # defines RikkiTikkiAPI.getOptions
    RikkiTikkiAPI.getOptions = => __options.valueOf()
    # invokes callback if defined
    callback? null, true
  ## connect(dsn, options)
  # > Manually create connection to Mongo Database Server
  connect:(dsn,opts)->
    # defines __conn with Connection
    @__conn = new RikkiTikkiAPI.Connection
    # adds listener for open events
    @__conn.once 'open', (evt)=>
      # defines RikkiTikkiAPI.getConnection
      RikkiTikkiAPI.getConnection = => @__conn
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
      console.log "SyncService.__instance: #{SyncService.__instance}"
      delete SyncService.__instance
      console.log "SyncService.__instance [post delete]: #{SyncService.__instance}"
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
#> CONFIG_PATH: Filesystem path to the Config File. Default: ./configs
RikkiTikkiAPI.CONFIG_PATH         = "#{process.cwd()}#{path.sep}configs"
#> CONFIG_FILENAME: Name for the Config File. Default: db.json
RikkiTikkiAPI.CONFIG_FILENAME     = 'db.json'
#> SCHEMA_PATH: Filesystem path to the Schema Files. Default: ./schemas
RikkiTikkiAPI.SCHEMA_PATH         = "#{process.cwd()}#{path.sep}schemas"
RikkiTikkiAPI.SCHEMA_TREES_FILE   = 'schema.json'
#> WRAP_SCHEMA_EXPORTS: Wrap Generated Schemas with a `model`. Default: true
RikkiTikkiAPI.WRAP_SCHEMA_EXPORTS = true


#### Static API Methods

## getConnection()
#> returns the current DB Connection
RikkiTikkiAPI.getConnection = ->
  @connection
## getAPIPath()
#> returns the Base REST path for the API Client
RikkiTikkiAPI.getAPIPath = ->
  "#{RikkiTikkiAPI.API_BASEPATH}/#{RikkiTikkiAPI.API_VERSION}"
## createAdapter(type,options)
#> Creates an Routing Adapter of type <type>
RikkiTikkiAPI.createAdapter = (type,options)->
  for param in ['type','options']
    return throw "param '#{param}' is not defined" if typeof param == 'undefined' or param == null
  RikkiTikkiAPI.Adapters.createAdapter type, options
## getSchemaManager(type,options)
#> Returns the SchemaManager
RikkiTikkiAPI.getSchemaManager = ->
  SchemaManager.getInstance()
## getSchemaTreeManager(type,options)
#> Returns the SchemaTreeManager
RikkiTikkiAPI.getSchemaTreeManager = ->
  SchemaTreeManager.getInstance()
## getCollectionManager()
#> Returns the CollectionManager
RikkiTikkiAPI.getCollectionManager = ->
  CollectionManager.getInstance()
## getCollectionManitor()
#> Returns the CollectionManager
RikkiTikkiAPI.getCollectionManitor = ->
  CollectionMonitor.getInstance()
## getSchemaTree(name)
#> retrieves SchemaTree if exists
RikkiTikkiAPI.getSchemaTree = (name)->
  if (tree = SchemaTreeManager.getInstance().__trees[name]) then tree else {}
## listCollections()
#> Returns list of all collection names currently in Database
RikkiTikkiAPI.listCollections = ->
  @getCollectionManitor().getNames()
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
  # defined JS function that will be invoked with new constructor
  model = `function model(data, opts) { if (!(this instanceof RikkiTikkiAPI.model)) return _.extend(arguments.callee, new RikkiTikkiAPI.Document( data, opts )); }`
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

RikkiTikkiAPI.Util              = require './classes/utils'
RikkiTikkiAPI.base_classes      = require './classes/base_class'
RikkiTikkiAPI.APIOptions        = require './classes/config/APIOptions'
_types                          = require './classes/types'
RikkiTikkiAPI.OperationTypes    = _types.OperationTypes
_dsn                            = require './classes/dsn'
RikkiTikkiAPI.DSNOptions        = _dsn.DSNOptions
RikkiTikkiAPI.DSN               = _dsn.DSN
_connections                    = require './classes/connections'
RikkiTikkiAPI.Connection        = _connections.Connection
_router                         = require './classes/router'
RikkiTikkiAPI.Router            = _router.Router
RikkiTikkiAPI.RoutingParams     = _router.RoutingParams
RikkiTikkiAPI.ConfigLoader      = require './classes/config/ConfigLoader'
RikkiTikkiAPI.Schema            = require './classes/schema/Schema'
RikkiTikkiAPI.APISchema         = require './classes/schema/APISchema'
RikkiTikkiAPI.ClientSchema      = require './classes/schema/ClientSchema'
SchemaManager                   = require './classes/schema/SchemaManager'
SchemaTree                      = require './classes/schema_tree/SchemaTree'
SchemaTreeManager               = require './classes/schema_tree/SchemaTreeManager'
SyncService                     = require './classes/services/SyncService'
RikkiTikkiAPI._adapters         = require './classes/adapters'
_collections                    = require './classes/collections'
CollectionManager               = _collections.CollectionManager
CollectionMonitor               = _collections.CollectionMonitor
RikkiTikkiAPI.Collection        = _collections.Collection
RikkiTikkiAPI.Document          = _collections.Document
Model                           = _collections.Model