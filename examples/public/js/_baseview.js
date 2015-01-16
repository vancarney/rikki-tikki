global = typeof exports !== "undefined" && exports !== null ? exports : window;
if (typeof global.Demo == "undefined")
    Demo = global.Demo = {};
$(function() {
    'use strict';
    Demo.BaseView = Backbone.View.extend({
        __children: [],
        __parent: {},
        render: function() {
          var _this = this;
          if (typeof this.subviews !== 'undefined' && (this.subviews != null) && _.isObject(this.subviews)) {
            _.each(this.subviews, (function(view, selector) {
              if (typeof view === 'undefined') {
                return;
              }
              return _.each(_this.$el.find(selector), function(v, k) {
                return _this.__children.push((_this[selector] = new view({
                  el: v,
                  __parent: _this
                })));
              });
            }));
            this.delegateEvents();
          }
          return this.childrenComplete();
        },
    
        setElement: function(el) {
          if (el) {
            this.$el = $(this.el = el);
          }
          this.delegateEvents();
          return this.$el;
        },
    
        childrenComplete: function() {},
    
        initialize: function(o) {
          if ((o != null) && o.el) {
            this.setElement(o.el);
          }
          if ((o != null) && o.__parent) {
            this.__parent = o.__parent;
          }
          if (typeof this.init === 'function') {
            if (o != null) {
              this.init(o);
            } else {
              this.init();
            }
          }
          return this.render();
        }
    });
    
});