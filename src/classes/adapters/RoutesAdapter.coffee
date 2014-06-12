url  = require 'url'
path  = require 'path'
{_} = require 'underscore'
module.exports.RikkiTikkiAPI = RikkiTikkiAPI = module.parent.parent.exports
class RoutesAdapter extends RikkiTikkiAPI.base_classes.AbstractAdapter
  required:['router']
  routes: []
  addRoute:(route, method, handler)->
    fn = if (match = @params.router.match route)? then match.fn else {}
    fn[method.toUpperCase()] = handler
    @routes = _.union @routes, route
    @params.router.addRoute route, fn
  requestHandler:(req, res)=>
    normalPathname = path.normalize(pathname = (parsed = url.parse req.url).pathname).replace /\\/g, '/'
    route = @params.router.match normalPathname
    return if !route
    req.params  = route.params
    req.query   = RikkiTikkiAPI.Util.Query.queryToObject req.url.split('?').pop()
    if (route.route? and @routes.lastIndexOf route.route) >= 0
      return route.fn[req.method] req, res
    else
      return route.fn req, res
  responseHandler:(res, data)->
    res.setHeader 'Content-Type', 'application/json'
    res.writeHead "#{data.status}", if data.status != 200 then "#{data.content}" else 'ok'
    res.end if data.status == 200 then JSON.stringify data.content else ""
module.exports = RoutesAdapter