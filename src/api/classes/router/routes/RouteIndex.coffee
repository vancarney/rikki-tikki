{_}       = require 'underscore'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
class RouteIndex extends RikkiTikkiAPI.base_classes.BaseRoute
  constructor:(callback)->
    RouteIndex.__super__.constructor.call @
    sanitize = (query)->
      filter  = null
      filtered = []
      restricted = []
      filter = _.partial _.without, _.keys query
      # remove each valid query operator from the query object keys
      _.each RikkiTikkiAPI.OperationTypes.query, (v)=> filtered = filter v
      _.each filtered, (v,k)=>
        # remove unknown or missapplied operators
        delete query[v] if v.match /^\$/
        # remove restricted fields
        delete query[v] if restricted.indexOf v >= 0
      query
    return (req,res)=>
      @createCollection req.params.collection if RikkiTikkiAPI.isDevelopment()
      @__db.getMongoDB().collection req.params.collection, (e,collection)=>
        collection.find sanitize( JSON.parse req.query.where || "{}" ), (e,results)=>
          return callback? res, {status:500, content: 'failed to execute query'} if e?
          return callback? res, {status:200, content: results}
module.exports = RouteIndex