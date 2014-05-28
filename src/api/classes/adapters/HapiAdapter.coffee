module.exports.RikkiTikkiAPI = RikkiTikkiAPI = module.parent.parent.exports
class HapiAdapter extends RikkiTikkiAPI.base_classes.AbstractAdapter
  required:['app']
  addRoute:(route, method, handler)->
    @params.app.route path:route, method:method, handler:handler
  router:-> @params.server
module.exports = HapiAdapter