{ObjectID, Binary} = require 'mongodb'
Str = module.parent.exports.String
Obj = require 'obj-utils'
Obj.isHash = (value)->
  if typeof value == 'object'
    return !(Array.isArray value or value instanceof Date or value instanceof ObjectId or value instanceof BinData)
  false
Obj.getMongoType = (obj)->
  throw 'Util.Object.getMongoType() requires an argument' if obj == undefined
  return Str.capitalize type if (type = typeof obj) != 'object' 
  return 'Array' if obj && obj.constructor == Array
  return 'null' if obj is null
  return 'ObjectID' if ObjectID(obj).getTimestamp() instanceof Date
  return 'Date' if obj instanceof Date
  if (obj instanceof Binary)
      BinaryTypes = {}
      BinaryTypes[0x00] = 'generic'
      BinaryTypes[0x01] = 'function'
      BinaryTypes[0x02] = 'old'
      BinaryTypes[0x03] = 'UUID'
      BinaryTypes[0x05] = 'MD5'
      BinaryTypes[0x80] = 'user'
      return "Binary-#{BinaryTypes[obj.subtype()]}"
  return 'Object'
module.exports = Obj
