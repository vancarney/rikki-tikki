{_}           = require 'underscore'
fs            = require 'fs'
path          = require 'path'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI || module.parent.exports
Util          = RikkiTikkiAPI.Util
class SchemaTree extends RikkiTikkiAPI.base_classes.AbstractLoader
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
      SchemaTree.__super__.load.call @, (e, data) =>
        return callback? e if e?
        @_data = JSON.parse data, @reviver
        callback? null, @__data
    else
      @__data = {}
      callback? null, @__data
  create:(path, data={}, callback)->
    SchemaTree.__super__.create.call @, path, JSON.stringify(data, @replacer), callback
module.exports = SchemaTree