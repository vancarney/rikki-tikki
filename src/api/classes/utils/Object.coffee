{ObjectId, BinData} = require 'mongodb'
Fun = module.parent.exports.Function
Obj = {}
Obj.getTypeOf = (obj)-> Object.prototype.toString.call(obj).slice 8, -1
Obj.isOfType = (value, kind)->
  (@getTypeOf value) == (Fun.getFunctionName kind) or value instanceof kind
Obj.isHash = (value)->
  if typeof value == 'object'
    return !(Array.isArray value or value instanceof Date or value instanceof ObjectId or value instanceof BinData)
  false
module.exports = Obj