{_} = require 'underscore'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
class AbstractAdapter
  required:[]
  constructor:(@params={})->
    if (RikkiTikkiAPI.Util.getFunctionName arguments.callee.caller.__super__.constructor ) != 'AbstractAdapter'
      return throw "AbstractAdapter can not be directly instatiated. Use a subclass instead."
    _.each @required, (param)=>
      throw Error "required param '#{param}' was not defined in the adapter params object" if !(@params.hasOwnProperty param)
    @
  requestHandler:(req,res)->
  responseHandler:(req,res)->
  addRoute:(route, method, handler)->
module.exports = AbstractAdapter