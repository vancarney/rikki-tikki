RouteIndex    = require './RouteIndex'
RouteShow     = require './RouteShow'
RouteCreate   = require './RouteCreate'
RouteUpdate   = require './RouteUpdate'
RouteDestroy  = require './RouteDestroy'
class Routes extends Object
  constructor: (@__db, @__adapter)->
  createRoute:(method, path, operation)->
    @__adapter.addRoute path, method, Routes[operation]?( @__db, @__adapter.responseHandler )

Routes.show = (@__db, callback)->
  return new RouteShow @__db, callback

Routes.update = (@__db, callback)->
  return new RouteUpdate @__db, callback

Routes.create = (@__db, callback)->
  return new RouteCreate @__db, callback

Routes.destroy  = (@__db, callback)->
  return new RouteDestroy @__db, callback

Routes.index = (@__db, callback)->
  return new RouteIndex @__db, callback
module.exports = Routes
module.exports.RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI