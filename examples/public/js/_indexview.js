global = typeof exports !== "undefined" && exports !== null ? exports : window;
if (typeof global.Demo == "undefined")
    Demo = global.Demo = {};
$(function() {
    'use strict';
    Demo.IndexView = Backbone.View.extend({
        events: {
            'click #collection_create':function(evt) {
                
            }
        },
        
        init:function(o) {
            
        }
    });
});