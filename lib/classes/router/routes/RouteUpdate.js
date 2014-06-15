// Generated by CoffeeScript 1.7.1
var RikkiTikkiAPI, RouteUpdate,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI;

RouteUpdate = (function(_super) {
  __extends(RouteUpdate, _super);

  function RouteUpdate() {
    return RouteUpdate.__super__.constructor.apply(this, arguments);
  }

  RouteUpdate.prototype.handler = function(callback) {
    return (function(_this) {
      return function(req, res) {
        return _this.handler.update(function(e, result) {
          return typeof callback === "function" ? callback(res, e != null ? e : result) : void 0;
        });
      };
    })(this);
  };

  return RouteUpdate;

})(RikkiTikkiAPI.base_classes.AbstractRoute);

module.exports = RouteUpdate;