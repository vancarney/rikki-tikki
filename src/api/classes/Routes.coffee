ObjectID = require('mongodb').ObjectID
class RikkiTikkiAPI.Routes extends Object
  constructor: (@__db, @__adapter)->
  createRoute:(method, path, operation)->
    console.log RikkiTikkiAPI.Routes[operation]?(@__adapter.responseHandler)
    @__adapter.addRoute path, method, RikkiTikkiAPI.Routes[operation]?(@__db,@__adapter.responseHandler)
RikkiTikkiAPI.Routes.show = (@__db, callback)->
  (req,res)=>
    console.log 'show'
    callback? res, status:200, content:{action:'show', results:[]}
RikkiTikkiAPI.Routes.update = (@__db, callback)->
  (req,res)=>
    console.log 'update'
    callback? res, status:200, content:{action:'update', results:[]}
RikkiTikkiAPI.Routes.create = (@__db, callback)->
  (req,res)=>
    req.on 'data', (data)=> 
      d =  JSON.parse data
      @__db.getMongoDB().collection 'Products', (e,collection)=> 
        collection.insert d, (e,result)=>
          return callback? res, {status:500, content: 'failed to create record'} if e? and result[0]._id?
          return callback? res, {status:200, content: _id:result[0]._id}
        
RikkiTikkiAPI.Routes.destroy  = (@__db, callback)->
  (req,res)=>
    console.log 'destroy'
    callback? res, status:200, content:{action:'destroy', results:[]}
RikkiTikkiAPI.Routes.index = (@__db, callback)->
  (req,res)=>
    console.log 'index'
    callback? res, status:200, content:{action:'index', results:[]}
# export Routes = Routes