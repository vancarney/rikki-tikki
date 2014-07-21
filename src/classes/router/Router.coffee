{_}           = require 'underscore'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
Routes        = require './routes'
RoutingParams = require './RoutingParams'
ClientRenderer  = require '../client/ClientRenderer'
class Router extends Object #RikkiTikkiAPI.base_classes.Singleton
  constructor:->
    throw "Routing Adapter not defined." if !(@__adapter = RikkiTikkiAPI.getAdapter())
    @__api_path = RikkiTikkiAPI.getAPIPath()
    client = new ClientRenderer
    setTimeout (=>
      @__client = client.toSource()
    ), 50
    @__routes   = new Routes
  getAdapter:-> @__adapter
  intializeRoutes:->
    @__adapter.addRoute "#{@__api_path}/__schema__", 'get', (req,res)=>
      @__adapter.responseHandler res, 
        status:200
        content: RikkiTikkiAPI.getSchemaManager().toJSON RikkiTikkiAPI.Util.Env.isDevelopment()
    @__adapter.addRoute "#{@__api_path}/client.js", 'get', (req,res)=>
      @__adapter.responseHandler res, (
        status:200
        content: @__client
      ), 'Content-Type':'text/javascript'
    RikkiTikkiAPI.DEBUG && logger.log 'debug', "#{name}:"
    # generate routes based on the REST operations
    for operation in ['index','show','create','update','destroy']
      collections = if RikkiTikkiAPI.Util.Env.isDevelopment() then [':collection'] else RikkiTikkiAPI.getSchemaManager().listSchemas()
      _.each collections, (collection)=>
        switch operation
          # matches GET with id param
          when 'show'
            path = "#{@__api_path}/#{collection}/:id"
          # matches POST or PUT with id param
          when 'update'
            path = "#{@__api_path}/#{collection}/:id"
          # matches POST with no param
          when 'create'
            path = "#{@__api_path}/#{collection}"
          # matches DELETE with id param
          when 'destroy'
            path = "#{@__api_path}/#{collection}/:id"
          # matches GET with no param
          when 'index'
            path = "#{@__api_path}/#{collection}"
          else
            # throws error if path is fubar
            throw new Error "unrecognized REST operation type: '#{operation}'"
        # adds the route to the adapter
        @addRoute route = new RoutingParams path, operation
        # handles debug
        RikkiTikkiAPI.DEBUG && logger.log 'debug', "#{route.method.toUpperCase()} #{route.path} -> #{route.operation}"
  addRoute:(params={})->
    # ensure params is cast to RikkiTikkiAPI.RoutingParams
    params = new RoutingParams params.path, params.operation if !RikkiTikkiAPI.Util.Object.isOfType params, RoutingParams
    # throw "Handler was invalid" if !params.handler or typeof handler != 'function'
    @__adapter.addRoute params.path, params.method, handler if (handler = @__routes.createRoute params.method, params.path, params.operation)?
module.exports = Router