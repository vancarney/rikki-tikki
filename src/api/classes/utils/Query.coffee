{_} = require 'underscore'
#### RikkiTikki.querify(object)
# > Returns passes object as Key/Value paired string
Query = {}
Query.objectToQuery = (object)->
  ( _.map _.pairs( object || {} ), (v,k)=>v.join '=' ).join '&'
Query.queryToObject = (string)->
  o={}
  decodeURIComponent(string).replace('?','').split('&').forEach (v,k)=> o[p[0]] = p[1] if (p = v.split '=').length == 2
  o
module.exports = Query 