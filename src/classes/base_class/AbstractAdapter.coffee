{_}   = require 'lodash'
Util  = require '../utils'
class AbstractAdapter extends Object
  required:[]
  constructor:(@params={})->
    if 'AbstractAdapter' == Util.Function.getConstructorName @ 
      throw 'AbstractAdapter can not be directly instatiated\nhint: use a subclass instead.'
    _.each @required, (param)=>
      throw Error "required param '#{param}' was not defined in the adapter params object" if !(@params.hasOwnProperty param)
  requestHandler:(req,res)->
    throw "#{Util.Function.getConstructorName @}.requestHandler(req,res) is not implemented" 
  responseHandler:(req,res)->
    throw "#{Util.Function.getConstructorName @}.responseHandler(req,res) is not implemented"
  addRoute:(route, method, handler)->
    throw "#{Util.Function.getConstructorName @}.addRoute(route, method, handler) is not implemented"
module.exports = AbstractAdapter