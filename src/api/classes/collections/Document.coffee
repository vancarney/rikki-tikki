{_}           = require 'underscore'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
class Document extends Object
  __data:{}
  constructor:(data, opts={})->
    @errors = null
    @__schema = opts.schema || {validators:{}}
    @setData data if data
  setData:(data)->
    _.each data, (v,k)=> 
      v = Util.stripNull v if typeof v == 'string'
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
    serialize = (document, parentKey, maxDepth)->
      for key in document
        continue if !(document.hasOwnProperty key) 
        branch[subKey = "#{parentKey}#{key}"] = value = document[key]
        serialize value, "#{subKey}.", maxDepth - 1 if (Util.Object.isHash value) and (maxDepth > 0)
    serialize @__data, '', maxDepth
    branch
module.exports = Document