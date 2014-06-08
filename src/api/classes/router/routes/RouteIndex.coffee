{_}       = require 'underscore'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
class RouteIndex extends RikkiTikkiAPI.base_classes.AbstractRoute
  handler:(callback)->   
    (req,res)=>
      @createCollection req.params.collection if RikkiTikkiAPI.Util.Env.isDevelopment()
      @__db.getMongoDB().collection req.params.collection, (e,collection)=>
        collection.find @sanitize( JSON.parse req.query.where || "{}" ), (e,results)=>
          return callback? res, {status:500, content: 'failed to execute query'} if e?
          return callback? res, {status:200, content: results}
module.exports = RouteIndex