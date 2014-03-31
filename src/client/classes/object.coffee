#### RikkiTikki.Object
# > Represents a single Record Association
class RikkiTikki.Object extends Backbone.Model
  #### idAttribute
  # > maps our Backbone.Model id attribute to the Api's _id attribute
  idAttribute: '_id'
  #### constructor(attrs, opts)
  # > Class Constructor Method
  constructor:(attrs, opts)->
    # passes `arguments` to __super__
    super attrs, opts
    # writes warning to console if the Object's `className` was not detected
    if (@className ?= RikkiTikki.getConstructorName @) == RikkiTikki.UNDEFINED_CLASSNAME
      console.warn 'RikkiTikki.Object requires className to be defined'
    # pluralizes the `className`
    else
      @className = RikkiTikki.Inflection.pluralize @className
  #### url() 
  # > generates a Parse API URL for this object based on the Class name
  url : ->
    "#{RikkiTikki.API_URI}/#{@className}#{if !@isNew() then '/'+(@get 'objectId') else ''}#{if (p=RikkiTikki.querify @__op).length then '?'+p else ''}"
  #### sync(method, model, [options])
  # > Overrides `Backbone.Model.sync` to apply custom API header and data
  sync : (method, model, options={})->
    # obtains new API Header Object
    opts = RikkiTikki.apiOPTS()
    
    encode = (o)->
      if _.isObject o and o.hasOwnProperty '_toPointer' and typeof o._toPointer == 'function' 
        o = o._toPointer()
      o
      
    if method.match /^(create|read)+$/
      _.each model.attributes, (v,k)=>
        v = encode v if _.isObject v
        if _.isArray v
          _.map v, (o) => if _.isObject then encode o else o
    # sets the encoded request data to request header
    opts.data = if !@_query then JSON.stringify @.toJSON() else "where=#{@_query.toJSON()}"
    # sets `options.url` to avoid duplicate test in `__super__.sync`
    RikkiTikki.validateRoute options.url ?= _.result(@, 'url') || '/'
    
    # calls `sync` on __super__
    Object.__super__.sync.call @, method, model, _.extend( options, opts )
  #### set(attributes, [options])
  # > Overrides `Backbone.Model.set`
  set: (attrs,opts)->
    # map all RikkiTikki.Objects to Pointers
    # _.each attrs, (v,k)=>
      # if v.hasOwnProperty '_toPointer' and typeof v._toPointer == 'Function'
        # v = v._toPointer() 
        # if (oV = @get k )?.__op?
          # (oV.objects ?= []).push v
        # else
          # k:{__op:"AddRelation", objects:[v]}
    # calls `set` on __super__
    # attrs = RikkiTikki._encode attrs
    s = Object.__super__.set.call @, attrs, opts
    # sets `__isDirty` to true if attributes have changed
    @__isDirty = true if @changedAttributes()
    s
  save:(attributes, options={})->
    self = @
    RikkiTikki.Object._findUnsavedChildren @attributes, children = [], files = []
    if children.length
      RikkiTikki.Object.saveAll children,
        completed: (m,r,o) =>
          if m.responseText? and (rt = JSON.parse m.responseText) instanceof Array
            _.each @attributes, (v,k)=>
              if v instanceof RikkiTikki.Object and v.get?( 'objectId' ) == rt[0].success.objectId
                console.log p = v._toPointer()
                @attributes[k] = {__op:"AddRelation", objects:[p]} 
          Object.__super__.save.call self, attributes, 
            success: => 
              console.log 'saved object!'
              options.completed? m,r,o
            error: -> console.log 'save failed'
          
        success: (m,r,o) => options.success? m,r,o
        error:   (m,r,o) => options.error? m,r,o
    else
      # calls `save` on __super__
      Object.__super__.save.call @, attributes, options
  #### toJSON([options])
  # > Overrides `Backbone.Model.toJSON`
  toJSON : (options)->
    # calls `toJSON` on __super__
    data = Object.__super__.toJSON.call @, options
    # cleans the object
    delete data.createdAt
    delete data.updatedAt
    data
  #### toFullJSON(seenObjects)
  # > Encodes Object to Parse formatted JSON object
  _toFullJSON: (seenObjects)->
    # loops on `_.clone` of Object attributes and applies `RikkiTikki._encodes`
    _.each (json = _.clone @attributes), (v, k) -> json[key] = RikkiTikki._encode v, seenObjects
    # loops on `__op` and sets to JSON object
    _.each @__op, (v, k) -> json[v] = k
    # sets `objectId` from `id`
    json.objectId  = @id if _.has @, 'id'
    # sets `createdAt` from attributes
    json.createdAt = (if _.isDate @createdAt then @createdAt.toJSON() else @createdAt) if _.has @, 'createdAt'
    # sets `updatedAt` from attributes
    json.updatedAt = (if _.isDate @updatedAt then @updatedAt.toJSON() else @updatedAt) if _.has @, 'updatedAt'
    # sets `__type` to Object
    json.__type    = 'Object'
    # sets `className` from Object properties
    json.className = @className
    # returns the JSON object
    json
  #### nestCollection(attributeName, collection)
  nestCollection: (aName, nCollection) ->
    # setup nested references
    for item, i in nCollection
      @attributes[aName][i] = (nCollection.at i).attributes
    # create empty arrays if none
    nCollection.bind 'add', (initiative) =>
      if !@get aName
        @attributes[aName] = []
      (@get aName).push initiative.attributes
    # remove arrays
    nCollection.bind 'remove', (initiative) =>
      updateObj = {}
      updateObj[aName] = _.without (@get aName), initiative.attributes 
      @set updateObj
    # return
    nCollection
  #### __op
  # > Holder for Object operations
  __op: null
  #### _serverData
  # > holder for data as last fetched from server
  _serverData:{}
  #### _opSetQueue
  # > Holder for Object operations Queue
  _opSetQueue: [{}]
  #### __isDirty
  # > indicates if any attribute has changed since last save
  __isDirty:false
  #### dirty()
  # > returns true if Object `attributes` have changed
  dirty:->
    @__isDirty or @hasChanged()
  #### _toPointer()
  # > Returns a `Pointer` reference of this `Object` for use by `RikkiTikki._encode`
  _toPointer: ->
    # throws an error if we try to get a`Pointer` of an item with no id
    throw new Error 'Can\'t serialize an unsaved RikkiTikki.Object' if @isNew()
    # returns the pointer
    __type: 'Pointer'
    className: @className
    objectId: @id
  #### _finishFetch(serverData, hasData)
  # > Cleans up Object properties
  _finishFetch: (serverData, hasData)->
    console.log "_finishFetch"
    # resets `_opSetQueue`
    @_opSetQueue = [{}]
    # handles special attributes
    @_mergeMagicFields serverData
    # decodes `serverData`
    _.each serverData, (v, k) => @_serverData[key] = RikkiTikki._decode k, v
    # stores `hasData` to object scope
    @_hasData = hasData
    # resets `__isDirty`
    @__isDirty = false
  #### _mergeMagicFields(attrs)
  # > Returns a `Pointer` reference of this `Object` for use by `RikkiTikki._encode`
  _mergeMagicFields: (attrs)->
    # loops through field names
    _.each ['id', 'objectId', 'createdAt', 'updatedAt'], (attr)=>
        if attrs[attr]
          # switches on existing attributes
          switch attrs[attr]
            # handles `objectId`
            when 'objectId'
              @id = attrs[attr] 
            # handles `createdAt` and `updatedAt`
            when 'createdAt', 'updatedAt'
              @[attr] = if !_.isDate attrs[attr] then RikkiTikki._parseDate attrs[attr] else attrs[attr]
          # deletes the attribute
          delete attrs[attr]
          
          
  ## Atomic Operations
  # > Parse API Operation Methods
  #
         
          
  #### add(attr, object)
  # > Concats passed objects to an Array attribute
  add:(attr, objects)->
    # tests for array and applies `concat`
    @set (({})[attr] = a.concat objects), null if _.isArray (a = @get 'attr')
    # returns changedAttributes object
    @changedAttributes()
  #### addUnique(attr, object)
  # > Uniquely adds passed objects to an Array attribute
  addUnique:(attr, objects)->
    # tests for array and applies `_.union`
    @set (({})[attr] = _.union a, objects), null if _.isArray (a = @get 'attr')
    # returns changedAttributes object
    @changedAttributes()
  #### increment(attr, amount)
  # > Increments a Number to the passed value or by 1
  increment: (attr, amount)->
    # tests for Number and adds given value
    @set ({})[attr] = a + (amount ?= 1), null if _.isNumber (a = @get 'attr')
    # returns changedAttributes object
    @changedAttributes()
  addRelation:(key,relation)->
    (@__op ?= new RikkiTikki.OP @).addRelation key, relation
  removeRelation:(key,relation)->
    (@__op ?= new RikkiTikki.OP @).removeRelation key, relation    
  createRelation:(key)->
    (@__op ?= new RikkiTikki.OP @).relation key 
  relation:(key)->
    @createRelation key    
          
          
## Static Methods
# > Parse API helper methods
#
          
          
#### RikkiTikki.Object._classMap
# > holder for user defined RikkiTikki.Objects
RikkiTikki.Object._classMap    = {}
#### RikkiTikki.Object._getSubclass
# > returns reference to user defined `RikkiTikki.Object` if `className` can be addressed
RikkiTikki.Object._getSubclass = (className)->
  # throws error if className is not a string
  throw 'RikkiTikki.Object._getSubclass requires a string argument.' if !_.isString className
  # sets className on `RikkiTikki.Object._classMap` if new and returns Class 
  RikkiTikki.Object._classMap[className] ?= if (clazz = RikkiTikki.Object._classMap[className]) then clazz else RikkiTikki.Object.extend className
#### RikkiTikki.Object._findUnsavedChildren
RikkiTikki.Object._findUnsavedChildren = (object, children, files)->
  _.each object, (obj)=>
    if (obj instanceof RikkiTikki.Object)
      children.push obj if obj.dirty()
      return
    # if (object instanceof RikkiTikki.File)
      # files.push obj if !obj.url()
      # return
#### RikkiTikki.Object._create
# > Creates an instance of a subclass of RikkiTikki.Object for the given classname
RikkiTikki.Object._create = (className, attr, opts)->
  # tests for existing Class as Function
  if typeof (clazz = RikkiTikki.Object._getSubclass className) is 'function'
    # returns the found class
    return new clazz attr, opts
  else
    # throws error if no class was found
    throw "unable to create #{className}"
#### RikkiTikki.Object.saveAll
# > Batch saves a given list of RikkiTikki.Objects
RikkiTikki.Object.saveAll = (list, options)->
  # create new `RikkiTikki.Batch` with the passed list
  (new RikkiTikki.Batch list
  ).exec
    # calls `Batch.exec` with callbacks
    success:(m,r,o)=>
      options.success m,r,o if options.success
    completed:(m,r,o)=>
      options.completed m,r,o if options.completed
    error:(m,r,o)=>
      options.error m,r,o if options.error
#### RikkiTikki.Object.destroyAll
# > Batch destroys a given list of RikkiTikki.Objects
RikkiTikki.Object.destroyAll = (list, options)->
  # create new `RikkiTikki.Batch` with the passed list
  (new RikkiTikki.Batch
  ).destroy list, 
    # calls `Batch.destroy` with callbacks
    success:(m,r,o)=>
      options.success m,r,o if options.success
    complete:(m,r,o)=>
      options.complete m,r,o if options.complete
    error:(m,r,o)=>
      options.error m,r,o if options.error