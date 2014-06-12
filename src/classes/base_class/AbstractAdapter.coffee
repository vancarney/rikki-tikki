{_} = require 'underscore'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
class AbstractAdapter extends Object
  required:[]
  constructor:(@params={})->
    if (RikkiTikkiAPI.Util.Function.getFunctionName arguments.callee.caller.__super__.constructor ) != 'AbstractAdapter'
      return throw "AbstractAdapter can not be directly instatiated. Use a subclass instead."
    _.each @required, (param)=>
      throw Error "required param '#{param}' was not defined in the adapter params object" if !(@params.hasOwnProperty param)
  requestHandler:(req,res)->
    throw "#{RikkiTikkiAPI.Util.Function.getConstructorName @}.requestHandler(req,res) is not implemented" 
  responseHandler:(req,res)->
    throw "#{RikkiTikkiAPI.Util.Function.getConstructorName @}.responseHandler(req,res) is not implemented"
  addRoute:(route, method, handler)->
    throw "#{RikkiTikkiAPI.Util.Function.getConstructorName @}.addRoute(route, method, handler) is not implemented"
module.exports = AbstractAdapter