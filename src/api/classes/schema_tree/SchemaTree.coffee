{_}           = require 'underscore'
fs            = require 'fs'
path          = require 'path'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
AbstractLoader = require '../loaders/AbstractLoader'
class SchemaTree extends AbstractLoader
  __data:{}
  constructor:(path)->
    @replacer = RikkiTikkiAPI.Schema.replacer
    @reviver  = RikkiTikkiAPI.Schema.reviver
    SchemaTree.__super__.constructor.call @, path
  set:(tree, opts, callback)->
    if typeof opts == 'function'
      callback = opts
      opts = {}
    @__data = _.extend @__data, tree #if typeof tree == 'string' then (o={})[tree] = opts else tree
    @save callback
  unset:(attr, callback)->
    delete @__data[attr] if @__data.hasOwnProperty attr
    @save callback
  load:(callback)->
    if @pathExists @__path
      SchemaTree.__super__.load.call @, (e) =>
        return callback? e if e?
        @_data = JSON.parse @__data, @reviver
        callback? null, @__data
    else
      @__data = {}
      callback? null, @__data
module.exports = SchemaTree