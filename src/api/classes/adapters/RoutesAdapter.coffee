class RikkiTikkiAPI.RoutesAdapter extends RikkiTikkiAPI.AbstractAdapter
  required:['router']
  addRoute:(route, method, handler)->
    fn = (@params.router.match req.path)?.fn || {}
    fn[method] = handler
    router.addRoute route, fn
    
    