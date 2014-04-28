AbstractAdapter = require './AbstractAdapter'
class ExpressAdapter extends AbstractAdapter
  required:['app']
  addRoute:(route, method, handler)->
    @params.app[method]? route, handler || @responseHandler
  responseHandler:(res, data)->
    console.log "data.content: #{data.content}"
    res.setHeader 'Content-Type', 'application/json'
    res.send data.status, data.content
module.exports = ExpressAdapter