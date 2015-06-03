{_}                   = require 'lodash'
# module.exports.Fleek  = Fleek
Util                  = require '../utils'
Singleton             = require '../base_class/Singleton'
Adapter               = require '../request_adapters/Adapter'
Routes                = require './routes'
RoutingParams         = require './RoutingParams'
ClientRenderer        = require '../client/ClientRenderer'
# SchemaManager         = (require '../schema/SchemaManager').getInstance()
class Router extends Singleton
  constructor:->
    Fleek   = require '../..'
    Adapter = require '../request_adapters/Adapter'
    throw "Routing Adapter not defined." unless (@__adapter = new Adapter app:Fleek.getApp())?
    @__api_path = Fleek.getApp().get 'restApiRoot'
    client    = new ClientRenderer
    @__routes = new Routes @__adapter
    @intializeRoutes()
    setTimeout (=>
      @__client = client.toSource()
    ), 50
  getAdapter:-> @__adapter
  getClient:-> @__client
  intializeRoutes:->
    Fleek   = require '../..'
    Fleek.DEBUG && logger.log 'debug', "#{name}:"
    # return unless Fleek.Util.Env.isDevelopment()
    # generate routes based on the REST operations
    for operation in ['index','show','create','update','destroy']
      switch operation
        # matches GET with id param
        when 'show'
          path = "#{@__api_path}/:collection/:id"
        # matches POST or PUT with id param
        when 'update'
          path = "#{@__api_path}/:collection/:id"
        # matches POST with no param
        when 'create'
          path = "#{@__api_path}/:collection"
        # matches DELETE with id param
        when 'destroy'
          path = "#{@__api_path}/:collection/:id"
        # matches GET with no param
        when 'index'
          path = "#{@__api_path}/:collection"
        else
          # throws error if path is fubar
          throw new Error "unrecognized REST operation type: '#{operation}'"
      # adds the route to the adapter
      @createRoute route = new RoutingParams path, operation
      # handles debug
      Fleek.DEBUG && logger.log 'debug', "#{route.method.toUpperCase()} #{route.path} -> #{route.operation}"
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
Fleek = require '../..'
module.exports = Router