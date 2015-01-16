global = typeof exports !== "undefined" && exports !== null ? exports : window;
if (typeof global.Demo == "undefined")
    Demo = global.Demo = {};
$(function() {
    'use strict';
    _.templateSettings = {
        interpolate: /\{\{(.+?)\}\}/g
    };
    rivets.configure({
        adapter: {
            subscribe: function(obj, keypath, callback) {
                return obj.on('change:' + keypath, callback);
            },
            unsubscribe: function(obj, keypath, callback) {
                return obj.off('change:' + keypath, callback);
            },
            read: function(obj, keypath) {
                return obj.get(keypath);
            },
            publish: function(obj, keypath, value) {
                return obj.set(keypath, value);
            }
        }
    });
    
    return new (Demo.BaseView.extend({
        el: "body",
        subviews: {
            
        },
        childrenComplete: function() {
            
        },
        createView: function(type) {
            
        },
        init: function(o) {
            console.log( Client.getAPIUrl() );
            Client.initialize({}, {
                success: function() {
                    console.log(arguments);
                }
            });
        }
    }))({
        model: new Backbone.Model({
            index:Demo.IndexView
        })     
    });
});