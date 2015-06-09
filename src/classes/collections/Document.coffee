{_}           = require 'lodash'
Util          = {}
Util.String   = require '../utils/String'
Util.Object   = require '../utils/Object'
class Document extends Object
  __data:{}
  constructor:(data, opts={})->
    @errors = null
    @__schema = opts.schema || {validators:{}}
    @setData data if data
  setData:(data)->
    _.each data, (v,k)=> 
      v = Util.String.stripNull v if typeof v == 'string'
    @__data = data
  validate:->
    if process.env != 'development'
      for k,v of attrs
        if (path = @__schema.paths[ k ])?
          for validator in path.validators || []
            return validator[1] if (validator[0] v) == false
        else
          return "#{@className} has no attribute '#{k}'" if k != @idAttribute
    return
  isValid:->
    @validate() == undefined
  valueOf:->
    @toJSON()
  toJSON:->
    if @isValid() then @__data else null
  serialize:(maxDepth)->
    branch = {}
    serialize = (doc, parentKey, maxDepth)=>
      for key,value of doc
        branch[subKey = "#{parentKey}#{key}"] = Util.Object.getMongoType value
        serialize value, "#{subKey}.", maxDepth - 1 if (Util.Object.isHash value) and (maxDepth > 0)
    serialize @__data, '', maxDepth
    branch
module.exports = Document
ApiHero = require '../..'
