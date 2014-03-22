#### RikkiTikki.apiOPTS
# > Generates a Parse compatible API Header
RikkiTikki.apiOPTS = ->
  contentType: "application/json"
  processData: false
  dataType: 'json'
  data: null
  headers:
    'Content-Type'            : 'application/json'
    'X-Parse-Application-Id'  : RikkiTikki.APP_ID
    'X-Parse-REST-API-Key'    : RikkiTikki.REST_KEY
    'X-Parse-Session-Token'   : RikkiTikki.SESSION_TOKEN
#### RikkiTikki.regEscape(string)
# > Returns string as RegExp string literal
RikkiTikki.regEscape = (string) -> string.replace /([\^\/\.\-\+\*\[\]\{\}\|\(\)\?\$]+)/g,'\\$1'
#### RikkiTikki.validateRoute(route)
# > Validates a given route
RikkiTikki.validateRoute = (route)->
  # throws error if route does not pass validation
  throw "Bad route: #{route}" if !route.match new RegExp "^(#{RikkiTikki.regEscape RikkiTikki.API_URI}\/)?(batch|classes|events|files|functions|login|push|requestPasswordReset|users|jobs)+"
  # returns true if no error thrown
  true
#### RikkiTikki._parseDate(iso8601)
# > Implementation of Parse._parseDate used to parse iso8601 UTC formatted `datetime`
RikkiTikki._parseDate = (iso8601)->
  # returns null if `iso8601` argument fails `RegExp`
  return null if (t = iso8601.match /^([0-9]{1,4})\-([0-9]{1,2})\-([0-9]{1,2})T+([0-9]{1,2}):+([0-9]{1,2}):?([0-9]{1,2})?(.([0-9]+))?Z+$/) == null
  # returns new `Date` from matched value
  new Date Date.UTC t[1] || 0, (t[2] || 1) - 1, t[3] || 0, t[4] || 0, t[5] || 0, t[6] || 0, t[8] || 0
#### RikkiTikki.querify(object)
# > Returns passes object as Key/Value paired string
RikkiTikki.querify = (obj)->
  ( _.map _.pairs( obj || {} ), (v,k)=>v.join '=' ).join '&'
#### RikkiTikki.getConstructorName
# > Attempts to safely determine name of the Class Constructor returns RikkiTikki.UNDEFINED_CLASSNAME as fallback
RikkiTikki.getConstructorName = (fun)->
  fun.constructor.name || if (name = RikkiTikki.getFunctionName fun.constructor)? then name else RikkiTikki.UNDEFINED_CLASSNAME
RikkiTikki.getFunctionName = (fun)->
  if (n = fun.toString().match /function+\s{1,}([A-Z]{1}[a-zA-Z]*)/)? then n[1] else null
#### RikkiTikki._encode
# > Attempts to JSON encode a given Object
RikkiTikki._encode = (value, seenObjects, disallowObjects)->
  # throws error if RikkiTikki.Model is passed while disallowed
  throw "RikkiTikki.Models not allowed here" if value instanceof RikkiTikki.Model and disallowObjects 
  # returns pointer value
  return value._toPointer() if value instanceof RikkiTikki.Object and value._toPointer? and typeof value._toPointer == 'function' #!seenObjects or _.include(seenObjects, value) or value.attributes != value.defaults
  # returns encoded RikkiTikki.Model
  return RikkiTikki._encode value._toFullJSON(seenObjects = seenObjects.concat value), seenObjects, disallowObjects if value.hasOwnProperty 'dirty' and typeof value.dirty == 'Function' and !value.dirty()
  # throws error if the object was new/unsaved
  throw 'Tried to save Model with a Pointer to an new or unsaved Object.' if value instanceof RikkiTikki.Object and value.isNew()
  # returns Data type as iso encoded object
  return __type:Date, iso: value.toJSON() if _.isDate value
  # returns map of encoded Arrays if value is Array
  return _.map value, ((v)-> RikkiTikki._encode v, seenObjects, disallowObjects) if _.isArray value
  # returns source of RegExp if value is RegExp
  return value.source if _.isRegExp value
  # returns RikkiTikki.Relation as JSON
  return value.toJSON() if (RikkiTikki.Relation and value instanceof RikkiTikki.Relation) or (RikkiTikki.Op and value instanceof RikkiTikki.Op) or (RikkiTikki.GeoPoint and value instanceof RikkiTikki.GeoPoint)
  # returns a File Object as a Pointer
  if RikkiTikki.File and value instanceof RikkiTikki.File
    throw 'Tried to save an object containing an unsaved file.' if !value.url()
    return (
      __type: "File"
      name: value.name()
      url: value.url()
    )
  # encodes an arbitrary object
  if _.isObject value
    o = {}
    _.each value, (v, k) -> o[k] = RikkiTikki._encode v, seenObjects, disallowObjects
    return o
  # returns raw object as fallback
  value
#### RikkiTikki._decode
# > Attempts to JSON decode a given Object
RikkiTikki._decode = (key, value)->
  # returns passed value if not an Object
  return value if !_.isObject value
  # handles Array values
  if _.isArray value
    _.each value, (v,k)->
      # recurses each Array value
      value[k] = RikkiTikki._decode k, v
    # returns array if sucessfully decoded
    return value
  # returns raw value if is `RikkiTikki.Object` 
  return value if (value instanceof RikkiTikki.Object) or (RikkiTikki.File and value instanceof RikkiTikki.File) or (RikkiTikki.OP and value instanceof RikkiTikki.Op)
  # returns decoded `RikkiTikki.OP` objects
  return RikkiTikki.OP._decode value if value.__op
  # recreates from Pointer
  if value.__type and value.__type == 'Pointer'
    p = RikkiTikki.Object._create value.className
    p._finishFetch {objectId: value.objectId}, false
    return p
  # recreates from Object
  if value.__type and value.__type == 'Object'
    cN = value.className
    delete value.__type
    delete value.className
    o = RikkiTikki.Object._create cN
    o._finishFetch value, true
    return o
  # returns `Date` value
  return RikkiTikki._parseDate value.iso if value.__type == 'Date'
  # recreates from `RikkiTikki.GeoPoint` reference
  if RikkiTikki.GeoPoint and value.__type == 'GeoPoint'
    return (new RikkiTikki.GeoPoint
      latitude: value.latitude
      longitude: value.longitude
    )
  # recreates from `RikkiTikki.Relation` reference
  if RikkiTikki.Relation and value.__type == 'Relation'
    (r = new RikkiTikki.Relation null, key).targetClassName = value.className
    return r
  # recreates from `RikkiTikki.File` reference
  if RikkiTikki.File and value.__type == 'File'
    (f = new sarse.File value.name).url = value.url
    return f
  # loops on and decodes and arbitrary object
  _.each value, (v, k) -> value[k] = RikkiTikki._decode k, v
  # returns the decoded object
  value