class RikkiTikkiAPI.ExpressAdapter extends RikkiTikkiAPI.AbstractAdapter
  required:['app']
  addRoute:(route, method, handler)->
    @params.app[method]? route, handler
  responseHandler:(res, data)->
    res.setHeader 'Content-Type', 'application/json'
    res.send data.status, data.content
  