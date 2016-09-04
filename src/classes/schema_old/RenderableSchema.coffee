{_}         = require 'lodash'
Util        = require '../utils'
Schema      = require './Schema'
APIOptions  = require '../config/APIOptions'
class RenderableSchema extends Schema
  toJSON:->
    _.clone @
  toString:(spacer)->
    JSON.stringify @, RenderableSchema.replacer, spacer
  toSource:->
    ns = unless (ns = (APIOptions.get 'api_namespace' )?.concat '.') is '.' then ns else ''
    schema = JSON.parse @toString()
    delete schema.name
    _.template(@__template) 
      name: Util.String.capitalize @name
      schema:schema
      ns:ns
      api_path: ( APIOptions.get 'schema_api_require_path' ) || ""
  constructor:(@name, obj, opts)->
    if Util.Object.isOfType obj, Schema
      _.extend @, obj
    else
      RenderableSchema.__super__.constructor.call @, obj, opts
RenderableSchema::__template = "// template was undefined"
RenderableSchema.replacer = (key,value)->
  return if value? and (0 > _.keys(Schema.reserved).indexOf key) then Util.Function.toString value else undefined
module.exports = RenderableSchema