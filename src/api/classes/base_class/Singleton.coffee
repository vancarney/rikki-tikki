RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
{EventEmitter}  = require 'events'
class Singleton extends EventEmitter
  constructor:->
    # references the constructor name for the sub-class
    cName = RikkiTikkiAPI.Util.Function.getConstructorName @
    # references the caller from the sub-class
    _caller       = arguments.callee.caller.caller
    # references the caller's sub-classee
    _caller_super = arguments.callee.caller
    # back references the caller chain until it find the origin
    while typeof _caller.__super__ != 'undefined'
      _caller_super = _caller
      _caller       = _caller.caller
    # tests if this object is sub-classes
    isDescended = (RikkiTikkiAPI.Util.Function.getFunctionName arguments.callee.caller.__super__.constructor ) == 'Singleton'
    # defines a test method to insure that the caller was invoked with a getInstance method
    matchSig = ((sig)=>
      (sig.replace /[\n\t]|[\s]{2,}/g, '' ) == "function () {return this.__instance != null ? this.__instance : this.__instance = new #{cName}();}"
    ) _caller.toString()
    # evaluates the test results to insure we are a valid singleton
    if  !isDescended || !matchSig  || typeof _caller_super.getInstance != 'function'
      return throw "#{cName} is a Singleton. Try creating/accessing with #{cName}.getInstance()"
module.exports = Singleton