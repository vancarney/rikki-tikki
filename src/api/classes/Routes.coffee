class RikkiTikkiAPI.Routes extends Object
  constructor: (@__db, @__adapter)->
  createRoute:(method, path, operation)->
    @__adapter.addRoute path, method, RikkiTikkiAPI.Routes[operation]?(@__db,@__adapter.responseHandler)

RikkiTikkiAPI.Routes.show = (@__db, callback)->
  return new RikkiTikkiAPI.RoutesShow @__db, callback

RikkiTikkiAPI.Routes.update = (@__db, callback)->
  return new RikkiTikkiAPI.RoutesUpdate @__db, callback

RikkiTikkiAPI.Routes.create = (@__db, callback)->
  return new RikkiTikkiAPI.RoutesCreate @__db, callback

RikkiTikkiAPI.Routes.destroy  = (@__db, callback)->
  return new RikkiTikkiAPI.RoutesDestroy @__db, callback

RikkiTikkiAPI.Routes.index = (@__db, callback)->
  return new RikkiTikkiAPI.RoutesIndex @__db, callback
# export Routes = Routes