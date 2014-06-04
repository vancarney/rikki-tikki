{_} = require 'underscore'
Util  = module.parent.exports
Fun = {}
Fun.getFunctionName = (fun)->
  if (n = fun.toString().match /function+\s{1,}([a-zA-Z_0-9]*)/)? then n[1] else null
#### RikkiTikki.getConstructorName
# > Attempts to safely determine name of the Class Constructor returns RikkiTikki.UNDEFINED_CLASSNAME as fallback
Fun.getConstructorName = (fun)->
  fun.constructor.name || if (name = @getFunctionName fun.constructor)? then name else null
Fun.construct = (constructor, args)->
  new ( constructor.bind.apply constructor, [null].concat args )
Fun.factory = Fun.construct.bind null, Function
Fun.fromString = (string)->
  if (m = string.match /^function+\s?\(([a-zA-Z0-9_\s\S\,]?)\)+\s?\{([\s\S]*)\}$/)?
    return Fun.factory _.union m[1], m[2]
  else
    return if (m = string.match new RegExp "^Native::(#{_.keys(@natives).join '|'})+$")? then @natives[m[1]] else null
Fun.toString = (fun)->
  return fun if typeof fun != 'function'
  if ((s = fun.toString()).match /.*\[native code\].*/)? then "Native::#{@getFunctionName fun}" else s
Fun.toSource = (fun)->
  return fun if typeof fun != 'function'
  if ((s = fun.toString()).match /.*\[native code\].*/)? then "#{@getFunctionName fun}" else s
Fun.natives  = 
  'Date':Date
  'Number':Number
  'String':String
  'Boolean':Boolean
  'Array':Array
  'Object':Object
module.exports = Fun