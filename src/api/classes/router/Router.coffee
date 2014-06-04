{_}           = require 'underscore'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
Routes        = require './routes'
RoutingParams = require './RoutingParams'
class Router extends RikkiTikkiAPI.base_classes.Singleton
  constructor:->
    throw "Routing Adapter not defined." if !(@__adapter = RikkiTikkiAPI.getAdapter())
    @__api_path = RikkiTikkiAPI.getAPIPath()
    @__routes   = new Routes
  getAdapter:-> @__adapter
  intializeRoutes:->
    @__adapter.addRoute "#{@__api_path}/__schema__", 'get', (req,res)=>
      @__adapter.responseHandler res, 
        status:200
        content: RikkiTikkiAPI.getSchemaManager().toJSON RikkiTikkiAPI.Util.Env.isDevelopment()
    RikkiTikkiAPI.DEBUG && logger.log 'debug', "#{name}:"
    # generate routes based on the REST operations
    for operation in ['index','show','create','update','destroy']
      collections = if RikkiTikkiAPI.Util.Env.isDevelopment() then [':collection'] else RikkiTikkiAPI.getSchemaManager().listSchemas()
      _.each collections, (collection)=>
        switch operation
          when 'show'
            path = "#{@__api_path}/#{collection}/:id"
          when 'update'
            path = "#{@__api_path}/#{collection}/:id"
          when 'create'
            path = "#{@__api_path}/#{collection}"
          when 'destroy'
            path = "#{@__api_path}/#{collection}/:id"
          when 'index'
            path = "#{@__api_path}/#{collection}"
          else
            throw new Error "unrecognized REST operation type: '#{operation}'"
        @addRoute route = new RoutingParams path, operation
        RikkiTikkiAPI.DEBUG && logger.log 'debug', "#{route.method.toUpperCase()} #{route.path} -> #{route.operation}"
  addRoute:(params={})->
    # ensure params is cast to RikkiTikkiAPI.RoutingParams
    params = new RoutingParams params.path, params.operation if !RikkiTikkiAPI.Util.Object.isOfType params, RoutingParams
    # throw "Handler was invalid" if !params.handler or typeof handler != 'function'
    @__adapter.addRoute params.path, params.method, handler if (handler = @__routes.createRoute params.method, params.path, params.operation)?
Router.getInstance = ->
  @__instance ?= new Router
module.exports = Router