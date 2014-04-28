BaseRoute = require './BaseRoute'
class RouteShow extends BaseRoute
  constructor:(@__db, callback)->
    return (req,res)=>
      req.on 'data', (data)=>
        _.each @before, (before,k)=> before req,res,data
        d =  JSON.parse data
        @__db.getMongoDB().collection req.params.collection, (e,collection)=> 
          collection.findOne {_id:req.params.id}, (e,result)=>
            _.each @after, (after,k)=> after req, res, result
            return callback? res, {status:500, content: 'failed to execute query'} if e? and result[0]._id?
            return callback? res, {status:200, content: resuilt}
module.exports = RouteShow