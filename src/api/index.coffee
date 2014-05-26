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
  __detected_adapter = null
  constructor:(dsn=null, @options=adapter:null)->
    # dsn=null, adapter=null
    for name in ['express','hapi']
      if RikkiTikkiAPI.Util.detectModule name
        @__detected_adapter ?= name
        break;
    if dsn != false
      @connect (if dsn? then dsn else (new RikkiTikkiAPI.ConfigLoader).toJSON()), {
        open:   => @emit 'open', null, @__conn
        error:  (e)=> @emit 'open', e, null
        close:  => @emit 'close'
      }
    @useAdapter if @options.adapter? then @options.adapter else 'routes'
    RikkiTikkiAPI.schemas = new RikkiTikkiAPI.SchemaLoader @options.schema_path || undefined #).toJSON() #.post.schema.valueOf()
  connect:(dsn,opts)-> 
    dsn = (new RikkiTikkiAPI.ConfigLoader dsn).toJSON() if dsn? and dsn instanceof String and dsn.match /\.json$/
    @__conn = new RikkiTikkiAPI.Connection
    @__conn.on 'open', (evt)=>
      RikkiTikkiAPI.connection = @__conn
      RikkiTikkiAPI.collectionMon = new RikkiTikkiAPI.CollectionMonitor @__conn
      RikkiTikkiAPI.collections   = new RikkiTikkiAPI.CollectionManager.getInstance()
      opts?.open? evt
    @__conn.on 'close', (evt) => opts?.close? evt
    @__conn.on 'error', (e)   => opts?.error? e
    @__conn.connect dsn
  disconnect:(callback)->
    @__conn.close callback
  listAdapters:->
    RikkiTikkiAPI.listRoutingAdapters()
  # getConnection:->
    # @__conn
  getAdapter:(name)->
    throw "RikkiTikkiAPI::getAdapter: Name is required" if !(name?)
    RikkiTikkiAPI.getRoutingAdapter name
  addAdapter:(name, adapter)->
    RikkiTikkiAPI.addRoutingAdapter name adapter
  useAdapter:(adapter)->
    if !(adapter?)
      throw 'param \'adapter\' is required'
    else
      if typeof adapter == 'string'
        if @listAdapters().indexOf( adapter ) >= 0
          @__adapter = @getAdapter adapter
        else
          throw "Routing Adapter '#{adapter}' was undefined"
      else
        if adapter instanceof RikkiTikkiAPI._adapters.AbstractAdapter
          @__adapter = adapter
        else
          throw "Routing Adapter must inherit from 'RikkiTikkiAPI.AbstractAdapter'"
  registerApp:(@__parent, adapter)->
    @useAdapter adapter || @__detected_adapter
    @__adapter = new @__adapter app:@__parent if typeof @__adapter == 'function'
    @router = new RikkiTikkiAPI.Router @__conn, @__adapter || null
module.exports = RikkiTikkiAPI
# Begin STATIC definitions
RikkiTikkiAPI.DEBUG = false
RikkiTikkiAPI.SCHEMA_PATH = './schemas'
RikkiTikkiAPI.API_BASEPATH = '/api'
RikkiTikkiAPI.API_VERSION  = '1'
RikkiTikkiAPI.API_NAMESPACE = ''
RikkiTikkiAPI.CONFIG_PATH = 'config'
RikkiTikkiAPI.CONFIG_FILENAME = 'db.json'
RikkiTikkiAPI.SCHEMA_TREES_FILE = 'schema.json'
RikkiTikkiAPI.getConnection = ->
  @connection
RikkiTikkiAPI.getEnvironment = ->
  process.env.NODE_ENV || 'development'
RikkiTikkiAPI.isDevelopment = ->
  @getEnvironment() == 'development'
RikkiTikkiAPI.getAPIPath = ->
  "#{RikkiTikkiAPI.API_BASEPATH}/#{RikkiTikkiAPI.API_VERSION}"
RikkiTikkiAPI.schemas  = null #{sku:Number, name:String, description:String}
RikkiTikkiAPI.getSchemas = ->
  @schemas
RikkiTikkiAPI.getFullPath = ->
  path.normalize "#{process.cwd()}#{path.sep}#{RikkiTikkiAPI.CONFIG_PATH}#{path.sep}#{RikkiTikkiAPI.CONFIG_FILENAME}"
RikkiTikkiAPI.listCollections = ->
  if RikkiTikkiAPI.collectionMon? then RikkiTikkiAPI.collectionMon.getNames() else []
RikkiTikkiAPI.configExists = (_path)->
  fs.existsSync if _path?.match /\.json$/ then _path else RikkiTikkiAPI.getFullPath()
# RikkiTikkiAPI.model = (name,schema={})->
  # throw "name is required for model" if !name
  # throw "name expected to be String type was '#{type}'" if (type = typeof name) != 'string'
  # model = `function model(name, schema) { if (!(this instanceof RikkiTikkiAPI.model)) return new RikkiTikkiAPI.model( name, schema ); }`
  # model.modelName = name
  # model.schema    = schema
  # model.toClientSchema = ->
    # new RikkiTikkiAPI.ClientSchema @modelName, @schema
  # model
# RikkiTikkiAPI.model::__proto__ 
# STATIC Class Definitions
RikkiTikkiAPI.Util              = require './classes/utils'
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
RikkiTikkiAPI.SchemaLoader      = require './classes/schema/SchemaLoader'
RikkiTikkiAPI.SchemaManager     = require './classes/schema/SchemaManager'
RikkiTikkiAPI.SchemaTreeManager = require './classes/schema_tree/SchemaTreeManager'
RikkiTikkiAPI._adapters         = require './classes/adapters'
_collections                    = require './classes/collections'
RikkiTikkiAPI.CollectionManager = _collections.CollectionManager
RikkiTikkiAPI.CollectionMonitor = _collections.CollectionMonitor
RikkiTikkiAPI.Document          = _collections.Document
RikkiTikkiAPI.Model             = _collections.Model
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