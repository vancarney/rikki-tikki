// Generated by CoffeeScript 1.7.1
var Fun, Util, _;

_ = require('underscore')._;

Util = module.parent.exports;

Fun = {};

Fun.getFunctionName = function(fun) {
  var n;
  if ((n = fun.toString().match(/function+\s{1,}([a-zA-Z_0-9]*)/)) != null) {
    return n[1];
  } else {
    return null;
  }
};

Fun.getConstructorName = function(fun) {
  var name;
  return fun.constructor.name || ((name = this.getFunctionName(fun.constructor)) != null ? name : null);
};

Fun.construct = function(constructor, args) {
  return new (constructor.bind.apply(constructor, [null].concat(args)));
};

Fun.factory = Fun.construct.bind(null, Function);

Fun.fromString = function(string) {
  var m;
  if ((m = string.match(/^function+\s?\(([a-zA-Z0-9_\s\S\,]?)\)+\s?\{([\s\S]*)\}$/)) != null) {
    return Fun.factory(_.union(m[1], m[2]));
  } else {
    if ((m = string.match(new RegExp("^Native::(" + (_.keys(this.natives).join('|')) + ")+$"))) != null) {
      return this.natives[m[1]];
    } else {
      return null;
    }
  }
};

Fun.toString = function(fun) {
  var s;
  if (typeof fun !== 'function') {
    return fun;
  }
  if (((s = fun.toString()).match(/.*\[native code\].*/)) != null) {
    return "Native::" + (this.getFunctionName(fun));
  } else {
    return s;
  }
};

Fun.toSource = function(fun) {
  var s;
  if (typeof fun !== 'function') {
    return fun;
  }
  if (((s = fun.toString()).match(/.*\[native code\].*/)) != null) {
    return "" + (this.getFunctionName(fun));
  } else {
    return s;
  }
};

Fun.natives = {
  'Date': Date,
  'Number': Number,
  'String': String,
  'Boolean': Boolean,
  'Array': Array,
  'Object': Object
};

module.exports = Fun;