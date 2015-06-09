{_} = require 'lodash'
SchemaItem = require './SchemaItem'
Util       = require '../utils'
class Schema extends Object
  ## Add
  add: (obj, prefix='')->
    _.each _.keys(obj), (key,k)=>
      pK = "#{prefix}#{key}"
      throw "Invalid value for Schema Path #{pK}" if key is null
      if _.isObject( value = obj[key] ) && (value.constructor || value.constructor.name == 'Object') && !value.type
        if _.keys(value).length
          @nested[pK] = true
          @add value, "#{pK}."
        else
          @path pK, value
      else
        @path pK, value
  ## Path
  path:(path, obj)->
    # if (obj == undefined)
      # return @paths[path] if @paths[path]
      # return @subpaths[path] if @subpaths[path]
      # return if /\.\d+\.?.*$/.test path then getPositionalPath @, path else undefined
    # throw "'#{path}' may not be used as a schema pathname" if ApiHero.Schema.reserved[path]
#    
    # last = (subpaths = path.split /\./).pop()
    # branch = @tree
    # _.each subpaths, (sub, i)=>
      # branch[sub] = {} if !branch[sub]
      # if typeof branch[sub] != 'object'
        # throw "Cannot set nested path '#{path}'. Parent path #{subpaths.slice(0, i).concat([sub]).join '.'} already set to type '#{branch[sub].name}'."
      # branch = branch[sub]
    # branch[last] = _.clone obj
    @paths[path] = new SchemaItem path, obj #Schema.interpretAsType path, obj
    @
  ## pathType
  pathType: (path)->
    return 'real' if path in @paths 
    return 'virtual' if path in @virtuals
    return 'nested' if path in @nested
    return 'real' if path in @subpaths
    if /\.\d+\.|\.\d+$/.test(path) && @getPositionalPath @, path then 'real' else 'adhocOrUndefined'
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
  constructor: (obj, @options={})->
    # @options = @defaultOptions options
    @paths = {}
    @subpaths = {}
    @virtuals = {}
    @nested = {}
    @inherits = {}
    @_indexes = []
    @methods = {}
    @statics = {}
    @tree = {}
    @options ={}
    @_requiredpaths = null
    @discriminatorMapping = null
    @_indexedpaths = null
    @add obj if obj? and !Util.Object.isOfType obj, Schema
  toModel: (name)->
    ApiHero.model name, @
Schema.nativeTypes =
  ['Object','Number','String','Boolean','Array']
## Schema.reserved
Schema.reserved = _.object _.map """
on,db,add,set,get,init,isNew,path,__path,pathType,errors,schema,options,modelName,__template,virtual,virtualpath,collection,toObject,toJSON,toModel,toString,toSource,constructor,emit,_events,_pres,_posts
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