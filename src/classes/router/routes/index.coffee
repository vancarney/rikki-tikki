RouteIndex    = require './RouteIndex'
RouteShow     = require './RouteShow'
RouteCreate   = require './RouteCreate'
RouteUpdate   = require './RouteUpdate'
RouteDestroy  = require './RouteDestroy'
class Routes extends Object
  __routes:{}
  afterAll:(fn)->
    throw "afterAll expects function type was <#{type}>" if (type = typeof fn) != 'function'
    for route, obj of @__routes
      for path, handler of obj
        handler.addAfterHandler fn
  beforeAll:(fn)->
    throw "beforeAll expects function type was <#{type}>" if (type = typeof fn) != 'function'
    for route, obj of @__routes
      for path, handler of obj
        handler.addBeforeHandler fn
  getRoute:(method,path)->
  constructor:(@__adapter)->
    throw "Routing Adapter not defined." unless @__adapter?
      
  createRoute:(method, path, operation)->
    if (@__adapter)
      (@__routes[path] ?= {})[method] = Routes[operation]? @__adapter.responseHandler
      # @__adapter.addRoute path, method, @__routes[path][method]
      # console.log @__routes[path][method]
      @__routes[path][method]

Routes.show = (callback)->
  return new RouteShow callback

Routes.update = (callback)->
  return new RouteUpdate callback

Routes.create = (callback)->
  return new RouteCreate callback

Routes.destroy = (callback)->
  return new RouteDestroy callback

Routes.index = (callback)->
  return new RouteIndex callback
module.exports = Routes
