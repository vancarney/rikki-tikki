// Generated by CoffeeScript 1.7.1
var RikkiTikkiAPI, SchemaLoader, SchemaManager, Util, fs, path, _,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

_ = require('underscore')._;

fs = require('fs');

path = require('path');

RikkiTikkiAPI = module.parent.exports;

Util = RikkiTikkiAPI.Util;

module.exports.RikkiTikkiAPI = RikkiTikkiAPI;

SchemaLoader = require('./SchemaLoader');

SchemaManager = (function(_super) {
  __extends(SchemaManager, _super);

  SchemaManager.__schemas = {};

  function SchemaManager() {
    this.__path = "" + (RikkiTikkiAPI.getOptions().schema_path);
    this.load();
  }

  SchemaManager.prototype.load = function() {
    var e, file, n, stat, _i, _len, _ref, _results;
    try {
      stat = fs.statSync(this.__path);
    } catch (_error) {
      e = _error;
      throw new Error(e);
    }
    if (stat != null ? stat.isDirectory() : void 0) {
      _ref = fs.readdirSync(this.__path);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        file = _ref[_i];
        if (file.match(/^(_|\.)+/)) {
          continue;
        }
        _results.push((this.__schemas != null ? this.__schemas : this.__schemas = {})[n = Util.File.name(file)] = new SchemaLoader(n));
      }
      return _results;
    }
  };

  SchemaManager.prototype.createSchema = function(name, data, callback) {
    if (data == null) {
      data = {};
    }
    if (typeof data === 'function') {
      callback = arguments[1];
      data = {};
    }
    return this.getSchema(name, (function(_this) {
      return function(e, s) {
        if (e != null) {
          return (_this.__schemas[name] = new SchemaLoader).create(name, data, callback);
        }
        return typeof callback === "function" ? callback(e, s) : void 0;
      };
    })(this));
  };

  SchemaManager.prototype.getSchema = function(name, callback) {
    var schema;
    if (this.__schemas == null) {
      this.__schemas = {};
    }
    if ((schema = this.__schemas[name]) != null) {
      return typeof callback === "function" ? callback(null, schema) : void 0;
    } else {
      return typeof callback === "function" ? callback("Schema '" + name + "' was not found", null) : void 0;
    }
  };

  SchemaManager.prototype.listSchemas = function(callback) {
    return typeof callback === "function" ? callback(null, _.keys(this.__schemas)) : void 0;
  };

  SchemaManager.prototype.saveSchema = function(name, callback) {
    return this.getSchema(name, (function(_this) {
      return function(e, schema) {
        if (e != null) {
          return typeof callback === "function" ? callback(e, null) : void 0;
        }
        return schema.save(callback);
      };
    })(this));
  };

  SchemaManager.prototype.renameSchema = function(name, newName, callback) {
    return this.getSchema(name, (function(_this) {
      return function(e, schema) {
        if (e != null) {
          return typeof callback === "function" ? callback(e, null) : void 0;
        }
        _this.__schemas[newName] = _.clone(schema);
        delete _this.__schemas[name];
        return schema.rename(name, newName, function(e, r) {
          return typeof callback === "function" ? callback(e, r) : void 0;
        });
      };
    })(this));
  };

  SchemaManager.prototype.saveAll = function(callback) {
    var eOut;
    eOut = [];
    _.each(this.__schemas, function(v, k) {
      return v.save((function(_this) {
        return function(e) {
          if (e) {
            return eOut.push(e);
          }
        };
      })(this));
    });
    return typeof callback === "function" ? callback((eOut.length ? eOut : null), null) : void 0;
  };

  SchemaManager.prototype.destroySchema = function(name, callback) {
    return this.getSchema(name, (function(_this) {
      return function(e, schema) {
        if (e != null) {
          return typeof callback === "function" ? callback(e, null) : void 0;
        }
        delete _this.__schemas[name];
        return schema.destroy(function(e, s) {
          return callback(e, s);
        });
      };
    })(this));
  };

  SchemaManager.prototype.toJSON = function(readable) {
    return JSON.parse(this.toString(readable));
  };

  SchemaManager.prototype.toString = function(readable) {
    return JSON.stringify({
      __meta__: this.__meta,
      __schemas__: this.__schemas
    }, SchemaLoader.replacer, readable ? 2 : void 0);
  };

  return SchemaManager;

})(RikkiTikkiAPI.base_classes.Singleton);

SchemaManager.getInstance = function() {
  return this.__instance != null ? this.__instance : this.__instance = new SchemaManager();
};

module.exports = SchemaManager;