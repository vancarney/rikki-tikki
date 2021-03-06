// Generated by CoffeeScript 1.9.0
var RikkiTikkiAPI, SchemaLoader, Util, path, _,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __hasProp = {}.hasOwnProperty;

_ = require('underscore')._;

path = require('path');

RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI || module.parent.exports;

module.exports.RikkiTikkiAPI = RikkiTikkiAPI;

Util = RikkiTikkiAPI.Util;

SchemaLoader = (function(_super) {
  __extends(SchemaLoader, _super);

  SchemaLoader.prototype.__data = {};

  function SchemaLoader(_at_name) {
    var e, _path;
    this.name = _at_name;
    _path = null;
    if (this.name) {
      _path = SchemaLoader.createPath(this.name);
    }
    try {
      SchemaLoader.__super__.constructor.call(this, _path);
    } catch (_error) {
      e = _error;
      this.emit.apply(this, ['error', e]);
    }
  }

  SchemaLoader.prototype.set = function(tree, opts, callback) {
    if (typeof opts === 'function') {
      callback = arguments[1];
      opts = {};
    }
    _.extend(this.__data, tree);
    return this.save(callback);
  };

  SchemaLoader.prototype.unset = function(attr, callback) {
    if (this.__data.hasOwnProperty(attr)) {
      delete this.__data[attr];
    }
    return this.save(callback);
  };

  SchemaLoader.prototype.load = function(_path, callback) {
    if (typeof _path === 'function') {
      callback = arguments[0];
      _path = null;
    } else {
      if (this.__path == null) {
        this.__path = _path;
      }
    }
    if (this.pathExists(this.__path)) {
      return SchemaLoader.__super__.load.call(this, (function(_this) {
        return function(e) {
          if (e != null) {
            return typeof callback === "function" ? callback(e) : void 0;
          }
          return typeof callback === "function" ? callback(null, _this.__data) : void 0;
        };
      })(this));
    } else {
      this.__data = {};
      return typeof callback === "function" ? callback(null, this.__data) : void 0;
    }
  };

  SchemaLoader.prototype.reload = function(callback) {
    delete require.cache[this.__path];
    return this.load(this.__path, callback);
  };

  SchemaLoader.prototype.create = function(_at_name, tree, callback) {
    this.name = _at_name;
    if (tree == null) {
      tree = {};
    }
    if (this.name == null) {
      return typeof callback === "function" ? callback("Name is required", null) : void 0;
    }
    this.__path = SchemaLoader.createPath(this.name);
    return this.save(callback);
  };

  SchemaLoader.prototype.rename = function(newName, callback) {
    return SchemaLoader.__super__.rename.call(this, SchemaLoader.createPath(this.name = newName), (function(_this) {
      return function(e, s) {
        return typeof callback === "function" ? callback((e != null ? "Could not rename Schema " + _this.name + "\r\t" + e : null), s) : void 0;
      };
    })(this));
  };

  SchemaLoader.prototype.destroy = function(callback) {
    if (!RikkiTikkiAPI.getOptions().get('destructive')) {
      return this.rename("_" + this.name, (function(_this) {
        return function(e, s) {
          return typeof callback === "function" ? callback((e != null ? "Schema.destroy failed\r\t" + e : null), s) : void 0;
        };
      })(this));
    } else {
      return SchemaLoader.__super__.destroy.call(this, (function(_this) {
        return function(e, s) {
          return typeof callback === "function" ? callback((e != null ? "Schema.destroy failed\r\t" + e : null), s) : void 0;
        };
      })(this));
    }
  };

  SchemaLoader.prototype.save = function(callback) {
    var model;
    if (this.__path == null) {
      return typeof callback === "function" ? callback("path was not defined") : void 0;
    }
    model = RikkiTikkiAPI.model(this.name, new RikkiTikkiAPI.Schema(this.__data));
    return Util.File.writeFile(this.__path, model.toAPISchema().toSource(), null, callback);
  };

  return SchemaLoader;

})(RikkiTikkiAPI.base_classes.AbstractLoader);

SchemaLoader.createPath = function(name) {
  return "" + (RikkiTikkiAPI.getOptions().get('schema_path')) + path.sep + name + ".js";
};

module.exports.RikkiTikkiAPI = RikkiTikkiAPI;

module.exports = SchemaLoader;
