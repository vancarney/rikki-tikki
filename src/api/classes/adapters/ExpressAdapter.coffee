class RikkiTikkiAPI.ExpressAdapter extends RikkiTikkiAPI.AbstractAdapter
  required:['app']
  addRoute:(route, method, handler)->
    @params.app[method] route, handler