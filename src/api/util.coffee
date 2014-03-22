RikkiTikkiAPI.Util ?= {}
RikkiTikkiAPI.Util.queryToObject = (string)->
  o={}
  string.replace('?','').split('&').forEach (v,k)=> o[p[0]] = p[1] if (p = v.split '=').length == 2
  o
#### RikkiTikki.querify(object)
# > Returns passes object as Key/Value paired string
RikkiTikkiAPI.Util.objectToQuery = (object)->
  ( _.map _.pairs( object || {} ), (v,k)=>v.join '=' ).join '&'
RikkiTikkiAPI.Util.getTypeOf = (obj)-> Object.prototype.toString.call(obj).slice 8, -1
RikkiTikkiAPI.Util.getFunctionName = (fun)->
  if (n = fun.toString().match /function+\s{1,}([A-Z]{1}[a-zA-Z]*)/)? then n[1] else null
RikkiTikkiAPI.Util.isOfType = (value, kind)->
  (@getTypeOf value) == (@getFunctionName kind) or value instanceof kind
