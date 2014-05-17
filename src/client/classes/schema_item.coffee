RikkiTikki.Types = 
  Array:Array
  Buffer:ArrayBuffer
  # Mixed:Object
  Date:Date
  Number:Number
  String:String
  
class RikkiTikki.SchemaItem
  constructor:(@path, obj={})->
    # sets up accessible params
    @index = false
    @instance = undefined
    @default = null
    @validators = []
    @getter = null
    @setter = null
    @options = {}
    @required = false
    # tests for native object as instance type
    for key, type of RikkiTikki.Types
      if type == obj
        @instance = obj 
        return
    # clones object for processing
    obj = _.clone obj
    @get obj.get if obj.get
    @set obj.set if obj.set
    # tests for `type` param
    if obj.type
      @instance = obj.type
      delete obj.type
    _.each ((_.partial _.without, _.keys(obj)).apply @, RikkiTikki.SchemaItem.allowed), (v)=> delete obj[v]
    # tests for validators
    if obj.validators
      @validators.push obj.validators
      delete obj.validators
    _.extend @, obj
  getDefault:->
    return null if !@hasDefault()
    if typeof @default is 'function' then (@default)() else @default
  hasDefault: -> @default?
  get:(fun)->
    if typeof fun is 'function'
      @getter = fun
    else
      throw "SchemaItem::get requires param to be type 'Function'. Type was #{typeof fun}"
  set:(fun)->
    if typeof fun is 'function'
      @setter = fun
    else
      throw "SchemaItem::set requires param to be type 'Function'. Type was #{typeof fun}"
  validate:(validator)->
    switch typeof validator
      when 'Function'
        @validators.push [validator, "#{@path} was invalid"]
      when 'Array'
        throw "Validator for #{path} was malformed" if !validator.length
        validator.push "#{@path} was invalid" if validator.length == 1
        @validators.push validator
      else
        throw "Validator requires either Function or Array type was '#{typeof validator}'"
RikkiTikki.SchemaItem.allowed = "index,default,validators,options,required".split ','