module.exports.RikkiTikkiAPI = RikkiTikkiAPI = module.parent.parent.exports
class ExpressAdapter extends RikkiTikkiAPI.base_classes.AbstractAdapter
  required:['app']
  addRoute:(route, method, handler)->
    @params.app[method]? route, handler || @responseHandler
  responseHandler:(res, data, headers)->
    if !headers
      res.setHeader 'Content-Type', 'application/json'
    else
      for header,value of headers
        res.setHeader header, value
    res.send data.status, data.content
module.exports = ExpressAdapter