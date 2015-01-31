{_} = require 'underscore'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
class RenderableSchema extends RikkiTikkiAPI.Schema
  toJSON:->
    _.clone @
  toString:(spacer)->
    JSON.stringify @, RenderableSchema.replacer, spacer
  toSource:->
    ns = (if (ns = RikkiTikkiAPI.API_NAMESPACE.concat('.')) != '.' then ns else '')
    schema = JSON.parse @toString()
    delete schema.name
    _.template(@__template) 
      name:RikkiTikkiAPI.Util.String.capitalize(@name)
      schema:schema
      ns:ns
      api_path:RikkiTikkiAPI.SCHEMA_API_REQUIRE_PATH || ""
  constructor:(@name, obj, opts)->
    if Util.Object.isOfType obj, RikkiTikkiAPI.Schema
      _.extend @, obj
    else
      RenderableSchema.__super__.constructor.call @, obj, opts
RenderableSchema::__template = "// template was undefined"
RenderableSchema.replacer = (key,value)->
  return if value? and (0 > _.keys(RikkiTikkiAPI.Schema.reserved).indexOf key) then Util.Function.toString value else undefined
module.exports = RenderableSchema