{_}                   = require 'lodash'
# module.exports.ApiHero  = ApiHero
Util                  = require '../utils'
Singleton             = require '../base_class/Singleton'
Adapter               = require '../request_adapters/Adapter'
Routes                = require './routes'
RoutingParams         = require './RoutingParams'
ClientRenderer        = require '../client/ClientRenderer'
APIOpts               = require '../config/APIOptions'
Adapter               = require '../request_adapters/Adapter'
# SchemaManager         = (require '../schema/SchemaManager').getInstance()
class Router extends Singleton
  constructor:->
    ApiHero   = require '../..'
    throw "Routing Adapter not defined." unless (@__adapter = new Adapter app:ApiHero.getApp())?
    @__api_path = @__adapter.params.app.get 'restApiRoot'
    client    = new ClientRenderer
    @__routes = new Routes @__adapter
    @intializeRoutes()
    setTimeout (=>
      @__client = client.toSource()
    ), 50
  getAdapter:-> @__adapter
  getClient:-> @__client
  intializeRoutes:->
    # return unless ApiHero.Util.Env.isDevelopment()
    # generate routes based on the REST operations
    for operation in ['index','create'] #['index','show','create','update','destroy']
      # adds the route to the adapter
      @createRoute route = new RoutingParams "#{@__api_path}/:collection", operation
      # handles debug
      logger.log 'debug', "#{route.method.toUpperCase()} #{route.path} -> #{route.operation}" if APIOpts.get 'debug'
  createRoute:(params)->
    # ensure params is cast to RikkiTikkiAPI.RoutingParams
    unless Util.Object.isOfType params, RoutingParams
      params = new RoutingParams params.path, params.operation 
    # throw "Handler was invalid" if !params.handler or typeof handler != 'function'
    if (handler = @__routes.createRoute params.method, params.path, params.operation)?
      @addRoute params.path, params.method, handler 
  addRoute:(path, method, handler)->
    @__adapter.addRoute path, method, handler
    # @__adapter.addRoute?.apply @, arguments
ApiHero = require '../..'
module.exports = Router