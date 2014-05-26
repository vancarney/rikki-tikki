{_} = require 'underscore'
Util  = module.parent.exports
Fun = {}
Fun.construct = (constructor, args)->
  new ( constructor.bind.apply constructor, [null].concat args )
Fun.factory = Fun.construct.bind null, Function
Fun.fromString = (string)->
  if (m = string.match /^function+\s?\(([a-zA-Z0-9_\s\S\,]?)\)+\s?\{([\s\S]*)\}$/)?
    return Fun.factory _.union m[1], m[2]
  else
    return if (m = string.match new RegExp "^Native::(#{_.keys(Fun.natives).join '|'})+$")? then Fun.natives[m[1]] else null
Fun.toString = (fun)->
  return fun if typeof fun != 'function'
  if ((s = fun.toString()).match /.*\[native code\].*/)? then "Native::#{Util.getFunctionName fun}" else s
Fun.toSource = (fun)->
  return fun if typeof fun != 'function'
  if ((s = fun.toString()).match /.*\[native code\].*/)? then "#{Util.getFunctionName fun}" else s
Fun.natives  = 
  'Date':Date
  'Number':Number
  'String':String
  'Boolean':Boolean
  'Array':Array
  'Object':Object
module.exports = Fun