{_}   = require 'underscore'
path  = require 'path'
Util  = {}
Util.capitalize = (string)->
  "#{string.charAt(0).toUpperCase()}#{string.slice(1)}"
Util.queryToObject = (string)->
  o={}
  decodeURIComponent(string).replace('?','').split('&').forEach (v,k)=> o[p[0]] = p[1] if (p = v.split '=').length == 2
  o
#### RikkiTikki.querify(object)
# > Returns passes object as Key/Value paired string
Util.objectToQuery = (object)->
  ( _.map _.pairs( object || {} ), (v,k)=>v.join '=' ).join '&'
Util.getTypeOf = (obj)-> Object.prototype.toString.call(obj).slice 8, -1
Util.getFunctionName = (fun)->
  if (n = fun.toString().match /function+\s{1,}([a-zA-Z_0-9]*)/)? then n[1] else null
#### RikkiTikki.getConstructorName
# > Attempts to safely determine name of the Class Constructor returns RikkiTikki.UNDEFINED_CLASSNAME as fallback
Util.getConstructorName = (fun)->
  fun.constructor.name || if (name = Util.getFunctionName fun.constructor)? then name else null
Util.isOfType = (value, kind)->
  (@getTypeOf value) == (@getFunctionName kind) or value instanceof kind
Util.detectModule = (name)->
  _.map( _.pluck( require.main.children, 'filename' ), (p)-> path.dirname(p).split(path.sep).pop()).indexOf( "#{name}" ) > -1
module.exports = Util
Util.Capabilities = require './Capabilities' 

