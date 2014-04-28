AbstractAdapter = require './AbstractAdapter'
class HapiAdapter extends AbstractAdapter
  required:['app']
  addRoute:(route, method, handler)->
    @params.app.route path:route, method:method, handler:handler
  router:-> @params.server
module.exports = HapiAdapter