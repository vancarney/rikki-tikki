{_} = require 'lodash'
# SchemaItem = require './SchemaItem'
Util          = require '../utils'
APIOptions    = require '../config/APIOptions'
SchemaRoller  = require 'schemaroller'
class Schema extends SchemaRoller.Schema
  ## virtual
  virtual: (name, options)->
    # virtuals = @virtuals
    # parts    = name.split( '.' )
    # name.split( '.' ).reduce ((mem, part, i, arr)-> console.log arguments), @tree
    # mem[part] || mem[part] = if (i == parts.length-1) then new ApiHero.VirtualType options, name else {}
    @virtuals[name] = name.split( '.' ).reduce ((mem, part, i, arr)->
      mem[part] || mem[part] = if (i == arr.length-1) then new ApiHero.VirtualType options, name else {}
    ), @tree
  ## virtualpath
  virtualpath: (name)->
    @virtuals[name]
  constructor: ->
    Schema.__super__.constructor.call @, _s = require './loopback.json'
  #### Options Element getter/setters
  ## setOption
  #> sets value on Options Hash
  #> params: name:<string>, value:<mixed>
  setOption: (name, value)->
    # attemptes to set property value on options element
    return false unless (_o = @get 'options')?
    _o.set name, value
  ## setOption
  #> sets value on Options Hash
  #> params: name:<string>, value:<mixed>
  getOption: (name)->
    return false unless (_o = @get 'options')?
    # returns value
    _o.get name
  setProperty: (name, value)->
    return false unless (_o = @get 'properties')?
    _o.set name, value
  getProperty: (name)->
    return false unless (_o = @get 'properties')?
    _o.get name
    
  setRelation: (name, value)->
    return false unless (_o = @get 'relations')?
    _o.set name, value
  getRelation: (name)->
    return false unless (_o = @get 'relations')?
    _o.get name        
  toModel: (name)->
    ApiHero.model name, @
  toJSON: ->
    _.clone @
  toString: (spacer)->
    JSON.stringify @, Schema.replacer, spacer
  toSource: (pretty=false)->
    ns = unless (ns = (APIOptions.get 'api_namespace' )?.concat '.') is '.' then ns else ''
    schema = @toString (if pretty then 2 else null)
    delete schema.name
    _.template(@__template) 
      name: Util.String.capitalize @name
      schema: schema
      ns:ns
      api_path: ( APIOptions.get 'schema_api_require_path' ) ? ""
Schema::__template = """
  name: <%=name%>
  schema: <%=schema%>
  ns: <%=ns%>
  api_path: <%=api_path%>
"""
Schema.replacer = (key,value)->
  return if value? and (0 > _.keys(Schema.reserved).indexOf key) then Util.Function.toString value else undefined
Schema.nativeTypes = [
  'Array', 'Boolean', 'Buffer', 'Date', 'null', 'Number', 'Object', 'String'
]
Schema.virtualTypes = ['any', 'GeoPoint', 'Vector' ]
## Schema.reserved
Schema.reserved = _.zipObject _.map """
on,db,set,get,init,isNew,errors,schema,options,modelName,__template,virtual,collection,toObject,toJSON,toModel,toString,toSource,constructor,emit,_events,_pres,_posts
""".split(','), (v)->[v,1]
Schema.replacer = (key,value)->
  value = value.toClientSchema() if value?.toClientSchema?
  if value? and (0 > _.keys( @reserved ).indexOf key) then Util.Function.toString value else undefined
Schema.reviver = (key,value)->
  # removes reserved element names from schema params
  return undefined if 0 <= _.keys( @reserved ).indexOf key
  # attempts to convert string to `Function` or `Object` and returns value
  if typeof value == 'string' and (fun = Util.Function.fromString value)? then fun else value
module.exports = Schema