#### RikkiTikki API Class
#> requires: lodash
{_}             = require 'lodash'
#> requires: events
{EventEmitter}  = require 'events'
#> requires: fs
fs              = require 'fs'
#> requires: path
path            = require 'path'
Util            = require './classes/utils'
  
global.logger   = console

# > Defines the `RikkiTikki` namespace in the 'global' environment
class ApiHero extends EventEmitter
  __defaultDSName = 'mongo'
  constructor:(app)->
    _.extend app.prototype, EventEmitter
    module.exports.getApp = => app
    services = []
    @router = ApiHero.Router.getInstance()
    @router.addRoute "/api-client/__schema__.json", 'get', (req,res)=>
      @router.getAdapter()?.responseHandler res,
        status:200
        content: ApiHero.SchemaManager.getInstance().toJSON Util.Env.isDevelopment()
    @router.addRoute "/api-client/client(\.js)?", 'get', (req,res)=>
      @router.getAdapter()?.responseHandler res, (
        status:200
        content: @router.getClient()
      ), 'Content-Type':'text/javascript'
    # app.get '/api/Fooberry', (req,res,next)-> console.log 'fooberry surprise'
    app.set 'legacyExplorer', false
    app.ApiHero = ApiHero
    app.on 'ready', =>
      # console.log JSON.stringify @params.app._router.stack, null, 2
      # @router = ApiHero.Router.getInstance()
      # @router.addRoute "/api-client/__schema__.json", 'get', (req,res)=>
        # @router.getAdapter()?.responseHandler res,
          # status:200
          # content: ApiHero.SchemaManager.getInstance().toJSON Util.Env.isDevelopment()
      # @router.addRoute "/api-client/client(\.js)?", 'get', (req,res)=>
        # @router.getAdapter()?.responseHandler res, (
          # status:200
          # content: @router.getClient()
        # ), 'Content-Type':'text/javascript'

    ApiHero.DSManager.getInstance().initialize (e,ok)=>
      app.emit 'ready' unless e?
      
    # app.dataSources.mongo.connect (e,db)-> 
      # app.emit 'ready'
      # for name in _.uniq _.map( _.keys( app.dataSources ), ((v)-> v.toLowerCase()))
        # services.push new SyncService app.dataSources[name]
        
      # app.dataSources.mongo.adapter.db.collections (e,res)->
        # dsList = _.uniq _.compact _.map _.values(res), (v)-> 
          # if (v.s.name.match /\.+/)? then null else name:v.s.name
        # for ds in dsList
          # SyncService

ApiHero.init = (app)-> 
  new ApiHero app

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
    
  
_.extend ApiHero, require './classes/router'
ApiHero.Util = require './classes/utils'
# create app dirs
cnf = new (require './classes/config/AppConfig')()
ApiHero.Util.File.ensureDirExists cnf.get 'data_path'
ApiHero.Util.File.ensureDirExists cnf.get 'trees_path'

# ApiHero.SchemaManager = require './classes/schema/SchemaManager'
# SyncService   = require './classes/services/SyncService'

Document              = require './classes/collections/Document'
# ApiHero.APISchema       = require './classes/schema/APISchema'
# ApiHero.ClientSchema    = require './classes/schema/ClientSchema'
  
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
  
  
  
ApiHero.DSManager     = require './classes/datasource/DataSourceManager'
# exports the API
module.exports = ApiHero