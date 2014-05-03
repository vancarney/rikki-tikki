{_} = require 'underscore'
RikkiTikkiAPI = module.parent.exports
Util          = RikkiTikkiAPI.Util
class ClientSchema extends RikkiTikkiAPI.Schema
  toJSON:->
    _.clone @
  toString:(spacer)->
    JSON.stringify @, ClientSchema.replacer, spacer
  toSource:->
    ns = (if (ns = RikkiTikkiAPI.API_NAMESPACE.concat('.')) != '.' then ns else '')
    schema = JSON.parse @toString()
    delete schema.name
    _.template ClientSchema.template, {name:RikkiTikkiAPI.Util.capitalize(@name), schema:schema, ns:ns}
  constructor:(@name, obj, opts)->
    ClientSchema.__super__.constructor.call @, obj, opts
ClientSchema.replacer = (key,value)->
  return if value? and (0 >= _.keys(RikkiTikkiAPI.Schema.reserved).indexOf key) then Util.Function.toString value else undefined
ClientSchema.template = """
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    __slice = [].slice;
  <%=ns%><%=name%> = (function(_super) {
      __extends(<%=name%>, _super);
      function <%=name%>() {
        <% _.each( schema, function(value,key) {%>
          this.<%=key%> = <%=JSON.stringify(value)%>;
        <%});%>
      }
  })(RikkiTikki.Schema);
);
"""
module.exports = ClientSchema