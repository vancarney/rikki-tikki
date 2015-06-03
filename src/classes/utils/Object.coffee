{ObjectID, Binary} = require 'mongodb'
Str = require '../utils/String'
Obj = require 'obj-utils'
Obj.isHash = (value)->
  if typeof value == 'object'
    return !(Array.isArray value or value instanceof Date or value instanceof ObjectId or value instanceof BinData)
  false
Obj.getMongoType = ->
  throw 'Util.Object.getMongoType() requires an argument' if arguments[0] == undefined
  return 'null' if (obj = arguments[0]) is null
  return Str.capitalize type unless (type = typeof obj) is 'object' 
  return 'Array' if obj && obj.constructor == Array
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
  return 'ObjectID' if typeof obj.hasOwnProperty 'getTimestamp' is 'function' and obj.getTimestamp() instanceof Date
  # return 'ObjectID' if "#{obj}".match /^[0-9a-z]{24,24}$/ and ObjectID(obj).getTimestamp() instanceof Date
  return 'Object'
module.exports = Obj
