# Includes Backbone & Underscore if the environment is NodeJS
{_}             = require 'underscore'
Backbone        = require 'backbone'
{EventEmitter}  = require 'events'
fs              = require 'fs'
path            = require 'path'
ArrayCollection = require('js-arraycollection').ArrayCollection
#### global.RikkiTikki
# > Defines the `RikkiTikki` namespace in the 'global' environment
class RikkiTikkiAPI extends EventEmitter
  __adapter:null
  constructor:(__options=new RikkiTikkiAPI.APIOptions, callback)->
    __options = new RikkiTikkiAPI.APIOptions __options if !(RikkiTikkiAPI.Util.isOfType __options, RikkiTikkiAPI.APIOptions)
    for name in ['express','hapi']
      if RikkiTikkiAPI.Util.detectModule name
        @__detected_adapter ?= name
        break
    RikkiTikkiAPI.getSchemas    = => RikkiTikkiAPI.SchemaManager.getInstance()
    RikkiTikkiAPI.useAdapter    = (adapter, options)=>
      if adapter
        if typeof adapter == 'string'
          if 0 <= RikkiTikkiAPI.Adapters.listAdapters().indexOf adapter
            @__adapter = new (RikkiTikkiAPI.Adapters.getAdapter adapter) options
          else
            throw "Routing Adapter '#{adapter}' was not registered. Use RikkiTikkiAPI.Adapters.registerAdapter(name, class)"
        else
          if adapter instanceof RikkiTikkiAPI.base_classes.AbstractAdapter
            @__adapter = adapter
          else
            throw "Routing Adapter must inherit from 'RikkiTikkiAPI.base_classes.AbstractAdapter'"
        if RikkiTikkiAPI.getConnection()?
          router.intializeRoutes() if @__adapter? and (router = RikkiTikkiAPI.Router.getInstance())?
        else
          @once 'open', =>
            router.intializeRoutes() if @__adapter? and (router = RikkiTikkiAPI.Router.getInstance())?
      else
        throw 'param \'adapter\' is required'
    RikkiTikkiAPI.getAdapter    = => @__adapter
    RikkiTikkiAPI.useAdapter adapter if (adapter = __options.get 'adapter')?
    (@__config = new RikkiTikkiAPI.ConfigLoader __options ).load (e, data)=>
      return callback? e if e?
      @connect (@__config.getEnvironment RikkiTikkiAPI.getEnvironment()), {
        open: =>
          RikkiTikkiAPI.useAdapter __options.adapter if __options.adapter?
          @emit 'open', null, @__conn
        error: (e)=> @emit 'open', e, null
        close: => @emit 'close'
      }
    RikkiTikkiAPI.getOptions    = => __options.valueOf()
    callback? null, true
  ## connect(dsn, options)
  # > Manually create connection to Mongo Database Server
  connect:(dsn,opts)-> 
    @__conn = new RikkiTikkiAPI.Connection
    @__conn.on 'open', (evt)=>
      RikkiTikkiAPI.connection = @__conn
      RikkiTikkiAPI.collectionMon = new RikkiTikkiAPI.CollectionMonitor @__conn
      RikkiTikkiAPI.collections   = new RikkiTikkiAPI.CollectionManager.getInstance()
      opts?.open? evt
    @__conn.on 'close', (evt) => opts?.close? evt
    @__conn.on 'error', (e)   => opts?.error? e
    @__conn.connect dsn
  ## disconnect(dsn, options)
  # > Manually closes connection to Mongo Database Server
  disconnect:(callback)->
    @__conn.close callback
  registerApp:(@__parent, adapter)->
    # @useAdapter adapter || @__detected_adapter
    # @__adapter = new @__adapter app:@__parent if typeof @__adapter == 'function'
    @router = new RikkiTikkiAPI.Router
module.exports = RikkiTikkiAPI
# Begin STATIC definitions
RikkiTikkiAPI.DEBUG = false
RikkiTikkiAPI.ADAPTER  = null
RikkiTikkiAPI.API_BASEPATH = 'api'
RikkiTikkiAPI.API_VERSION  = '1'
RikkiTikkiAPI.API_NAMESPACE = ''
RikkiTikkiAPI.CONFIG_PATH = "#{process.cwd()}#{path.sep}configs"
RikkiTikkiAPI.CONFIG_FILENAME = 'db.json'
RikkiTikkiAPI.SCHEMA_PATH = "#{process.cwd()}#{path.sep}schemas"
RikkiTikkiAPI.SCHEMA_TREES_FILE = 'schema.json'

RikkiTikkiAPI.getConnection = ->
  @connection
RikkiTikkiAPI.getEnvironment = ->
  process.env.NODE_ENV || 'development'
RikkiTikkiAPI.isDevelopment = ->
  @getEnvironment() == 'development'
RikkiTikkiAPI.getAPIPath = ->
  "#{RikkiTikkiAPI.API_BASEPATH}/#{RikkiTikkiAPI.API_VERSION}"
RikkiTikkiAPI.createAdapter = (name,options)->
  for param in ['name','options']
    return throw "param '#{param}' is not defined" if typeof param == 'undefined' or param == null
  RikkiTikkiAPI.Adapters.createAdapter name, options
RikkiTikkiAPI.getSchemaManager = ->
  RikkiTikkiAPI.SchemaManager.getInstance()
RikkiTikkiAPI.getCollectionManager = ->
  RikkiTikkiAPI.CollectionManager.getInstance()
RikkiTikkiAPI.getCollectionManitor = ->
  RikkiTikkiAPI.CollectionMonitor.getInstance()
RikkiTikkiAPI.listCollections = ->
  if RikkiTikkiAPI.collectionMon? then RikkiTikkiAPI.collectionMon.getNames() else []
# RikkiTikkiAPI.getFullPath = ->
  # path.normalize "#{process.cwd()}#{path.sep}#{RikkiTikkiAPI.CONFIG_PATH}#{path.sep}#{RikkiTikkiAPI.CONFIG_FILENAME}"
# RikkiTikkiAPI.configExists = (_path)->
  # fs.existsSync if _path?.match /\.json$/ then _path else RikkiTikkiAPI.getFullPath()
RikkiTikkiAPI.model = (name,schema={})->
  throw "name is required for model" if !name
  throw "name expected to be String type was '#{type}'" if (type = typeof name) != 'string'
  model = `function model(data, opts) { if (!(this instanceof RikkiTikkiAPI.model)) return _.extend(arguments.callee, new RikkiTikkiAPI.Document( data, opts )); }`
  model.modelName = name
  model.schema    = schema
  model.toClientSchema = ->
    new RikkiTikkiAPI.ClientSchema @modelName, @schema
  model.toAPISchema = ->
    new RikkiTikkiAPI.APISchema @modelName, @schema
  model
# Begin Included Class Registry
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
RikkiTikkiAPI.SchemaManager     = require './classes/schema/SchemaManager'
RikkiTikkiAPI.SchemaTreeManager = require './classes/schema_tree/SchemaTreeManager'
RikkiTikkiAPI._adapters         = require './classes/adapters'
_collections                    = require './classes/collections'
RikkiTikkiAPI.CollectionManager = _collections.CollectionManager
RikkiTikkiAPI.CollectionMonitor = _collections.CollectionMonitor
RikkiTikkiAPI.Document          = _collections.Document
RikkiTikkiAPI.Model             = _collections.Model