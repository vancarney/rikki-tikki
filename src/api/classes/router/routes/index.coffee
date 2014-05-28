RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
RouteIndex    = require './RouteIndex'
RouteShow     = require './RouteShow'
RouteCreate   = require './RouteCreate'
RouteUpdate   = require './RouteUpdate'
RouteDestroy  = require './RouteDestroy'
class Routes extends Object
  constructor:->
    if !(@__adapter = RikkiTikkiAPI.getAdapter())
      throw "Routing Adapter not defined."
  createRoute:(method, path, operation)->
    if (@__adapter)
      @__adapter.addRoute path, method, Routes[operation]?  @__adapter.responseHandler

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
