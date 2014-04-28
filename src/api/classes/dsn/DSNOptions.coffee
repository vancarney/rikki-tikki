{_}           = require 'underscore'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
#### RikkiTikkiAPI.DSNOptions
class DSNOptions extends Object
  constructor:(options)->
    @setOptions options if options
  setOptions:(options)->
    throw new Error 'options was undefined' if !options
    options = Util.queryToObject options if Util.isOfType options, String
    if !Util.isOfType options, DSNOptions
      try
        @__options = @__validate options
      catch e
        console.log "setOptions error: #{e}"
        return throw Error e
    else
      @__options = options.getOptions()
  getOptions:->
    @__options
  getReplicaSet:->
    @__options?.replicaSet || null
  getSSL:->
    @__options?.ssl || null
  getConnectTimeoutMS:->
    @__options?.connectTimeoutMS || null
  getSocketTimeoutMS:->
    @__options?.socketTimeoutMS || null
  getMaxPoolSize:->
    @__options?.maxPoolSize || null
  getMinPoolSize:->
    @__options?.minPoolSize || null
  getMaxIdleTimeMS:->
    @__options?.maxIdleTimeMS || null
  getWaitQueueMultiple:->
    @__options?.waitQueueMultiple || null
  getWaitQueueTimeoutMS:->
    @__options?.waitQueueTimeoutMS || null
  getW:->
    @__options?.w || null
  getWriteConcerns:->
    @__options?.w || null
  getWtimeoutMS:->
    @__options?.wtimeoutMS || null
  getJournal:->
    @__options?.journal || null
  getReadPreference:->
    @__options?.readPreference || null
  getReadPreferenceTags:->
    @__options?.readPreferenceTags || null
  getUuidRepresentation:->
    @__options?.uuidRepresentation || null
  # get:(key)->
    # @__options[key] || null
  # set:(key,val)->
    # @__options[key] = val if (@__test key, val) == null
  __validate:(object)->
    opts =
      replicaSet: 
        type: String
      ssl: 
        type: Boolean
      connectTimeoutMS: 
        type: Number
      socketTimeoutMS: 
        type: Number
      maxPoolSize: 
        type: Number
      minPoolSize: 
        type: Number
      maxIdleTimeMS: 
        type: Number
      waitQueueMultiple: 
        type: Number
      waitQueueTimeoutMS: 
        type: Number
      w: 
        type: [Number,String] 
        restrict: /^(\-?1+)|([0-9]{1})|(majority+)|(\{\w:\d\}+)$/
      wtimeoutMS: 
        type: Number
      journal: 
        type: Boolean
      readPreference: 
        type: String
        restrict: /^(primary+)|(primaryPreferred+)|(secondary+)|(secondaryPreferred+)|(nearest+)$/
      readPreferenceTags: 
        type: String
        restrict: /((\w+):+(\w|\d)+),?/g
        allowMutliple: true
      uuidRepresentation: 
        type: String
        restrict: /^(standard+)|(csharpLegacy+)|(javaLegacy+)|(pythonLegacy+)$/
    _.each object, (value, key)=>
      throw new Error "#{key} is not a valid Connection Option" if !opts[key]
      if (Util.isOfType opts[key].type, Array) and opts[key].type.length
        found = false
        _.each opts[key].type, (v)=> 
          found = true if Util.isOfType value, v
        throw new TypeError "#{key} is expected to be #{opts[key].type.join ' or '}. Was '#{typeof value}'" if !found
      else
        if !Util.isOfType value = opts[key].type(value), opts[key].type
          throw new TypeError "#{key} is expected to be #{opts[key].type}. Was #{typeof value}"
        # reset object[key] as properly typed value which has passed validation
        object[key] = value.valueOf()
      throw new Error "#{key} was malformed" if opts[key].restrict? and (value.match opts[key].restrict) == null
    object
  toJSON:->
    @__options
  toString:->
    Util.objectToQuery @__options
module.exports = DSNOptions