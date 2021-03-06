// Generated by CoffeeScript 1.9.0
var Binary, Obj, ObjectID, Str, _ref;

_ref = require('mongodb'), ObjectID = _ref.ObjectID, Binary = _ref.Binary;

Str = module.parent.exports.String;

Obj = require('obj-utils');

Obj.isHash = function(value) {
  if (typeof value === 'object') {
    return !(Array.isArray(value || value instanceof Date || value instanceof ObjectId || value instanceof BinData));
  }
  return false;
};

Obj.getMongoType = function(obj) {
  var BinaryTypes, type;
  if (obj === void 0) {
    throw 'Util.Object.getMongoType() requires an argument';
  }
  if ((type = typeof obj) !== 'object') {
    return Str.capitalize(type);
  }
  if (obj && obj.constructor === Array) {
    return 'Array';
  }
  if (obj === null) {
    return 'null';
  }
  if (ObjectID(obj).getTimestamp() instanceof Date) {
    return 'ObjectID';
  }
  if (obj instanceof Date) {
    return 'Date';
  }
  if (obj instanceof Binary) {
    BinaryTypes = {};
    BinaryTypes[0x00] = 'generic';
    BinaryTypes[0x01] = 'function';
    BinaryTypes[0x02] = 'old';
    BinaryTypes[0x03] = 'UUID';
    BinaryTypes[0x05] = 'MD5';
    BinaryTypes[0x80] = 'user';
    return "Binary-" + BinaryTypes[obj.subtype()];
  }
  return 'Object';
};

module.exports = Obj;
