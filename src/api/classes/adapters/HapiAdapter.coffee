class RikkiTikkiAPI.ExpressAdapter extends RikkiTikkiAPI.AbstractAdapter
  required:['app']
  addRoute:(route, method, handler)->
    @params.app.route path:route, method:method, handler:handler