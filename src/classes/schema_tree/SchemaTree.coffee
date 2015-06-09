{_}           = require 'lodash'
fs            = require 'fs'
path          = require 'path'
AbstractLoader= require '../base_class/AbstractLoader'
Util          = require '../utils'
Schema        = require '../schema/Schema'
class SchemaTree extends AbstractLoader
  # __data  : {}
  replacer : Schema.replacer
  reviver  : Schema.reviver
  # constructor:(path)->
    # SchemaTree.__super__.constructor.call @, path
    # @replacer = ApiHero.Schema.replacer
    # @reviver  = ApiHero.Schema.reviver
    # @__data   = {}
  set:(tree, opts, callback)->
    # @__data   = {}
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
        @__data = JSON.parse "#{JSON.stringify data}", @reviver
        callback? null, @__data
    else
      @__data = {}
      callback? null, @__data
  create:(path, data={}, callback)->
    SchemaTree.__super__.create.call @, path, JSON.stringify(data, @replacer), callback
module.exports = SchemaTree