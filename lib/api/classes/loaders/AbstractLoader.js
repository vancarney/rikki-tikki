// Generated by CoffeeScript 1.7.1
var AbstractLoader, RikkiTikkiAPI, Util, fs, path, _,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

_ = require('underscore')._;

fs = require('fs');

path = require('path');

RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI;

Util = RikkiTikkiAPI.Util;

AbstractLoader = (function(_super) {
  __extends(AbstractLoader, _super);

  AbstractLoader.prototype.__data = null;

  function AbstractLoader(__path) {
    this.__path = __path;
    if (this.__path != null) {
      this.load();
    }
  }

  AbstractLoader.prototype.pathExists = function(_path) {
    if (_path != null ? _path.match(/\.(json|js)+$/) : void 0) {
      return fs.existsSync(_path);
    } else {
      return false;
    }
  };

  AbstractLoader.prototype.load = function(callback) {
    var e;
    if (!this.__path) {
      throw "No load path defined";
    }
    if (!this.pathExists(this.__path)) {
      throw "path '" + this.__path + "' does not exist or is of incorrect type";
    }
    try {
      if (this.__path.match(/\.js+$/)) {
        this.__data = require(this.__path);
      } else {
        Util.File.readFile(this.__path, (function(_this) {
          return function(e, __data) {
            _this.__data = __data;
            return typeof callback === "function" ? callback(e, _this.__data) : void 0;
          };
        })(this));
      }
    } catch (_error) {
      e = _error;
      console.error("could load file '" + this.__path);
    }
    return typeof callback === "function" ? callback(e || null, this.__data) : void 0;
  };

  AbstractLoader.prototype.get = function(attr) {
    return this.__data[attr];
  };

  AbstractLoader.prototype.set = function(data) {
    return this.__data = data;
  };

  AbstractLoader.prototype.save = function(callback) {
    if (this.__path != null) {
      return Util.File.writeFile(this.__path, "" + (this.toString(true)), null, callback);
    } else {
      return typeof callback === "function" ? callback("path was not defined") : void 0;
    }
  };

  AbstractLoader.prototype.destroy = function(callback) {
    if ((this.__path != null) && this.pathExists(this.__path)) {
      return fs.unlink(this.__path, (function(_this) {
        return function(e) {
          return typeof callback === "function" ? callback(e) : void 0;
        };
      })(this));
    } else {
      return typeof callback === "function" ? callback("file '" + this.__path + "' does not exist") : void 0;
    }
  };

  AbstractLoader.prototype.create = function(__path, data, callback) {
    this.__path = __path;
    if (typeof data === 'function') {
      callback = data;
      data = null;
    }
    if ((this.__path != null) && !this.pathExists(this.__path)) {
      return this.save(callback);
    } else {
      throw "file '" + this.__path + "' already exists";
    }
  };

  AbstractLoader.prototype.replacer = null;

  AbstractLoader.prototype.valueOf = function() {
    return this.__data;
  };

  AbstractLoader.prototype.toJSON = function() {
    return JSON.parse(this.toString());
  };

  AbstractLoader.prototype.toString = function(readable) {
    if (readable == null) {
      readable = false;
    }
    return JSON.stringify(this.__data, this.replacer, readable ? 2 : void 0);
  };

  return AbstractLoader;

})(Object);

module.exports = AbstractLoader;