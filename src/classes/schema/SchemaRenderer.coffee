{_} = require 'underscore'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
class SchemaRenderer extends RikkiTikkiAPI.Schema
  toJSON:->
    _.clone @
  toString:(spacer)->
    JSON.stringify @, SchemaRenderer.replacer, spacer
  toSource:->
    ns = (if (ns = RikkiTikkiAPI.API_NAMESPACE.concat('.')) != '.' then ns else '')
    schema = JSON.parse @toString()
    delete schema.name
    _.template @__template, {name:RikkiTikkiAPI.Util.String.capitalize(@name), schema:schema, ns:ns}
  constructor:(@name, obj, opts)->
    if Util.Object.isOfType obj, RikkiTikkiAPI.Schema
      _.extend @, obj
    else
      SchemaRenderer.__super__.constructor.call @, obj, opts
SchemaRenderer::__template = "// template was undefined"
SchemaRenderer.replacer = (key,value)->
  return if value? and (0 >= _.keys(RikkiTikkiAPI.Schema.reserved).indexOf key) then Util.Function.toString value else undefined
module.exports = SchemaRenderer