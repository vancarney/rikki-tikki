class RikkiTikkiAPI.HapiAdapter extends RikkiTikkiAPI.AbstractAdapter
  required:['app']
  addRoute:(route, method, handler)->
    @params.app.route path:route, method:method, handler:handler
  router:-> @params.server