url  = require 'url'
path = require 'path'
class RikkiTikkiAPI.RoutesAdapter extends RikkiTikkiAPI.AbstractAdapter
  required:['router']
  routes: []
  requestHandler: (req,res)=>
    normalPathname = path.normalize(pathname = (parsed = url.parse req.url).pathname).replace /\\/g, '/'
    route = @params.router.match normalPathname
    return res.error 404 if !route
    if (@routes.lastIndexOf route.route) >= 0
      route.fn[req.method] req, res
    else
      route.fn req, res
  addRoute:(route, method, handler)->
    fn = if (match = @params.router.match route)? then match.fn else {}
    fn[method.toUpperCase()] = handler
    @routes = _.union @routes, route
    @params.router.addRoute route, fn