module.exports.RikkiTikkiAPI = RikkiTikkiAPI = module.parent.parent.exports
class ExpressAdapter extends RikkiTikkiAPI.base_classes.AbstractAdapter
  required:['app']
  addRoute:(route, method, handler)->
    @params.app[method]? route, handler || @responseHandler
  responseHandler:(res, data)->
    res.setHeader 'Content-Type', 'application/json'
    res.send data.status, data.content
module.exports = ExpressAdapter