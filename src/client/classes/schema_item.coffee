RikkiTikki.Types = 
  Array:Array
  Buffer:ArrayBuffer
  # Mixed:Object
  Date:Date
  Number:Number
  String:String
  
class RikkiTikki.SchemaItem
  constructor:(@path, obj)->
    @index = false
    @instance = undefined
    @default = null
    @validators = []
    @getter = null
    @setter = null
    @options = {}
    @required = false
    for key, type of RikkiTikki.Types
      if type == obj
        @instance = obj 
        return
    allowed = "index,default,validators,options,required".split ','
    @get obj.get if obj.get
    @set obj.set if obj.set
    if obj.type
      @instance = obj.type
      delete obj.type
    
    _.each ((_.partial _.without, _.keys(obj)).apply @, allowed), (v)=> delete obj[v]
    # console.log obj
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
    
