RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
class Singleton extends Object
  constructor:->
    cName = RikkiTikkiAPI.Util.getConstructorName @
    isDescended = (RikkiTikkiAPI.Util.getFunctionName arguments.callee.caller.__super__.constructor ) == 'Singleton'
    matchSig = ((sig)=>
      (sig.replace /[\n\t]|[\s]{2,}/g, '' ) == "function () {return this.__instance != null ? this.__instance : this.__instance = new #{cName}();}"
    ) arguments.callee.caller.caller.toString()
    if  !isDescended || !matchSig  || typeof arguments.callee.caller.getInstance != 'function'
      return throw "#{cName} is a Singleton. Try creating/accessing with #{cName}.getInstance()"
module.exports = Singleton
