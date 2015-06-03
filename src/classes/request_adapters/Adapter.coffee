AbstractAdapter = require '../base_class/AbstractAdapter'
class Adapter extends AbstractAdapter
  required:['app']
  constructor:(@params)->
  addRoute:(route, method, handler)->
    # console.log "#{route}: #{handler}"
    @params.app[method] route, (handler || @responseHandler)
  responseHandler:(res, data, headers)->
    if !headers
      res.setHeader 'Content-Type', 'application/json'
    else
      for header,value of headers
        res.setHeader header, value
    res
    .status data.status
    .send if data.content then data.content else ""
  requestHandler:->
    # not implemented
    false
module.exports = Adapter