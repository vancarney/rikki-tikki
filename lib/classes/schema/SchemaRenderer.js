// Generated by CoffeeScript 1.7.1
var RikkiTikkiAPI, SchemaRenderer, Util, _,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

_ = require('underscore')._;

RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI;

Util = RikkiTikkiAPI.Util;

SchemaRenderer = (function(_super) {
  __extends(SchemaRenderer, _super);

  SchemaRenderer.prototype.toJSON = function() {
    return _.clone(this);
  };

  SchemaRenderer.prototype.toString = function(spacer) {
    return JSON.stringify(this, SchemaRenderer.replacer, spacer);
  };

  SchemaRenderer.prototype.toSource = function() {
    var ns, schema;
    ns = ((ns = RikkiTikkiAPI.API_NAMESPACE.concat('.')) !== '.' ? ns : '');
    schema = JSON.parse(this.toString());
    delete schema.name;
    return _.template(this.__template, {
      name: RikkiTikkiAPI.Util.String.capitalize(this.name),
      schema: schema,
      ns: ns
    });
  };

  function SchemaRenderer(name, obj, opts) {
    this.name = name;
    if (Util.Object.isOfType(obj, RikkiTikkiAPI.Schema)) {
      _.extend(this, obj);
    } else {
      SchemaRenderer.__super__.constructor.call(this, obj, opts);
    }
  }

  return SchemaRenderer;

})(RikkiTikkiAPI.Schema);

SchemaRenderer.prototype.__template = "// template was undefined";

SchemaRenderer.replacer = function(key, value) {
  if ((value != null) && (0 > _.keys(RikkiTikkiAPI.Schema.reserved).indexOf(key))) {
    return Util.Function.toString(value);
  } else {
    return void 0;
  }
};

module.exports = SchemaRenderer;
