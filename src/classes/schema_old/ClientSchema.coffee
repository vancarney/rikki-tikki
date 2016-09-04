{_} = require 'lodash'
RenderableSchema  = require './RenderableSchema'
class ClientSchema extends RenderableSchema
ClientSchema::__template = """
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    __slice = [].slice;
  <%=ns%><%=name%> = (function(_super) {
      __extends(<%=name%>, _super);
      function <%=name%>() {
        <% _.each( schema, function(value,key) {%>
          this.<%=key%> = <%=typeof value == 'object' ? JSON.stringify(value, null, 2) : value%>;
        <%});%>
      }
  })(RikkiTikki.Schema);
);
"""
module.exports = ClientSchema