{_} = require 'underscore'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
class SchemaRenderer extends RikkiTikkiAPI.Schema
  toJSON:->
    _.clone @
  toString:(spacer)->
    JSON.stringify @, SchemaRenderer.replacer, spacer
  toSource:->
    ns = (if (ns = RikkiTikkiAPI.API_NAMESPACE.concat('.')) != '.' then ns else '')
    schema = JSON.parse @toString()
    delete schema.name
    _.template @__template, {name:RikkiTikkiAPI.Util.capitalize(@name), schema:schema, ns:ns}
  constructor:(@name, obj, opts)->
    if Util.isOfType obj, RikkiTikkiAPI.Schema
      _.extend @, obj
    else
      SchemaRenderer.__super__.constructor.call @, obj, opts
SchemaRenderer::__template = """
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    __slice = [].slice;
  <%=name%> = (function(_super) {
      __extends(<%=name%>, _super);
      function <%=name%>() {
        console.error('schema undefined');
      }
  })(RikkiTikki.Schema);
);
"""
SchemaRenderer.replacer = (key,value)->
  return if value? and (0 >= _.keys(RikkiTikkiAPI.Schema.reserved).indexOf key) then Util.Function.toString value else undefined
module.exports = SchemaRenderer