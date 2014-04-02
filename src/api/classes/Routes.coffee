ObjectID = require('mongodb').ObjectID
class RikkiTikkiAPI.Routes extends Object
  constructor: (@__db, @__adapter)->
  createRoute:(method, path, operation)->
    @__adapter.addRoute path, method, RikkiTikkiAPI.Routes[operation]?(@__db,@__adapter.responseHandler)
RikkiTikkiAPI.Routes.show = (@__db, callback)->
  (req,res)=>
    req.on 'data', (data)=> 
      d =  JSON.parse data
      @__db.getMongoDB().collection req.params.collection, (e,collection)=> 
        collection.findOne {_id:req.params.id}, (e,result)=>
          return callback? res, {status:500, content: 'failed to execute query'} if e? and result[0]._id?
          return callback? res, {status:200, content: resuilt}
RikkiTikkiAPI.Routes.update = (@__db, callback)->
  (req,res)=>
    req.on 'data', (data)=> 
      d =  JSON.parse data
      @__db.getMongoDB().collection req.params.collection, (e,collection)=> 
        delete d._id if d._id?
        collection.update {_id:req.params.id}, {$set:d}, (e,result)=>
          return callback? res, {status:500, content: 'failed to execute query'} if e?
          return callback? res, {status:204, content: ''}
RikkiTikkiAPI.Routes.create = (@__db, callback)->
  (req,res)=>
    req.on 'data', (data)=> 
      d =  JSON.parse data
      @__db.getMongoDB().collection req.params.collection, (e,collection)=> 
        collection.insert d, (e,result)=>
          return callback? res, {status:500, content: 'failed to create record'} if e? and result[0]._id?
          return callback? res, {status:200, content: _id:result[0]._id}
        
RikkiTikkiAPI.Routes.destroy  = (@__db, callback)->
  (req,res)=>
    req.on 'data', (data)=> 
      d =  JSON.parse data
      @__db.getMongoDB().collection req.params.collection, (e,collection)=> 
        collection.remove d, (e,result)=>
          return callback? res, {status:500, content: 'failed to delete record'} if e? and result[0]._id?
          return callback? res, {status:204, content: ''}
RikkiTikkiAPI.Routes.index = (@__db, callback)->
  (req,res)=>
    console.log req.query
    @__db.getMongoDB().collection req.params.collection, (e,collection)=> 
      console.log JSON.parse(req.query.where)
      collection.find JSON.parse(req.query.where), (e,results)=>
        console.log "results: #{results}"
        return callback? res, {status:500, content: 'failed to execute query'} if e?
        return callback? res, {status:200, content: results}
# export Routes = Routes