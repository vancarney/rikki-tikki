// Generated by CoffeeScript 1.7.1
var DSN, DSNOptions, RikkiTikkiAPI, Util, _,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

_ = require('underscore')._;

RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI;

DSNOptions = RikkiTikkiAPI.DSNOptions;

Util = RikkiTikkiAPI.Util;

DSN = (function(_super) {
  __extends(DSN, _super);

  DSN.prototype.__dsn = null;

  function DSN(dsn) {
    if (dsn) {
      this.setDSN((dsn instanceof String ? this.parseDSNString(dsn) : dsn));
    }
  }

  DSN.prototype.parseDSNString = function(string) {
    var dsnParams, pass, protoDSN;
    if ((dsnParams = string.match(/^(mongodb\:\/\/)?(.+:?.?@)?([a-z0-9\.]+)+(:[a-zA-Z0-9]{4,5})?\,?([a-zA-Z0-9\.\,:]*)?(\/\w+)?\??([a-zA-Z0-9\_=&\.]*)?$/)) !== null) {
      return protoDSN = {
        protocol: dsnParams[1] ? dsnParams[1].split(':').shift() : null,
        username: dsnParams[2] ? (pass = dsnParams[2].replace('@', '').split(':')).shift() : null,
        password: pass && pass.length ? "" + pass : null,
        host: dsnParams[3] || null,
        port: dsnParams[4] ? parseInt(dsnParams[4].split(':').pop()) : null,
        replicas: dsnParams[5] ? _.map(dsnParams[5].split(','), function(v, k) {
          var port;
          return {
            host: (port = v.split(':')).shift(),
            port: parseInt(port.shift())
          };
        }) : null,
        database: dsnParams[6] ? dsnParams[6].split('/').pop() : null,
        options: dsnParams[7] ? new RikkiTikkiAPI.DSNOptions(dsnParams[7]) : null
      };
    }
    return null;
  };

  DSN.prototype.setOptions = function(options) {
    return this.__dsn != null ? this.__dsn : this.__dsn = {};
  };

  DSN.prototype.getOptions = function() {
    var _ref;
    return ((_ref = this.__dsn) != null ? _ref.options : void 0) || null;
  };

  DSN.prototype.setDSN = function(dsn) {
    var e;
    if (Util.Object.isOfType(dsn, String)) {
      dsn = this.parseDSNString(dsn);
    }
    try {
      if (this.validate(dsn)) {
        return this.__dsn = dsn;
      }
    } catch (_error) {
      e = _error;
      throw Error(e);
    }
  };

  DSN.prototype.getDSN = function() {
    return this.__dsn || null;
  };

  DSN.prototype.validate = function(dsn) {
    var e, oTypes, options;
    oTypes = {
      protocol: {
        type: String,
        required: false,
        restrict: /^mongodb+$/
      },
      username: {
        type: String,
        required: false
      },
      password: {
        type: String,
        required: false
      },
      host: {
        type: String,
        required: true,
        restrict: /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])|(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$/
      },
      port: {
        type: Number,
        required: false,
        restrict: /^[0-9]{4,5}$/
      },
      replicas: {
        type: Array,
        required: false
      },
      database: {
        type: String,
        required: false
      },
      options: {
        type: RikkiTikkiAPI.DSNOptions,
        required: false
      }
    };
    _.each(oTypes, (function(_this) {
      return function(value, key) {
        if (dsn[key] != null) {
          if (!value.type) {
            throw Error("Validator for DSN::'" + key + "' was missing type param");
          }
          if (!(Util.Object.isOfType(dsn[key], value.type))) {
            throw Error("" + key + " was expected to be " + (Util.getFunctionName(value.type)) + ". Type was '" + (typeof dsn[key]) + "'");
          }
          if (value.restrict && !(("" + dsn[key]).match(value.restrict))) {
            throw Error("" + key + " was malformed");
          }
        } else if (value.required) {
          throw Error("" + key + " was required but not defined");
        }
      };
    })(this));
    if (options) {
      try {
        options = new DSNOptions(options);
      } catch (_error) {
        e = _error;
        throw Error(e);
      }
    }
    return true;
  };

  DSN.prototype.toJSON = function() {
    return this.__dsn;
  };

  DSN.prototype.toDSN = function() {
    var userPass;
    userPass = "" + (this.__dsn.username || '') + (this.__dsn.username && this.__dsn.password ? ':' + this.__dsn.password : '');
    return "" + (this.__dsn.protocol || 'mongodb') + "://" + userPass + (userPass.length ? '@' : '') + this.__dsn.host + ":" + (this.__dsn.port || '27017') + "/" + (this.__dsn.database || '') + (this.__dsn.options ? '?' + this.__dsn.options : '');
  };

  DSN.prototype.toString = function() {
    return this.toDSN();
  };

  return DSN;

})(Object);

module.exports = DSN;