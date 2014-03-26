class RikkiTikkiAPI.HapiAdapter extends RikkiTikkiAPI.AbstractAdapter
  required:['server']
  addRoute:(route, method, handler)->
    @params.server.route path:route, method:method, handler:handler
  router:-> @params.server