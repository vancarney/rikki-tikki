class RikkiTikkiAPI.RoutesShow extends Object
  constructor:(@__db, callback)->
    return (req,res)=>
      req.on 'data', (data)=> 
        d =  JSON.parse data
        @__db.getMongoDB().collection req.params.collection, (e,collection)=> 
          collection.findOne {_id:req.params.id}, (e,result)=>
            return callback? res, {status:500, content: 'failed to execute query'} if e? and result[0]._id?
            return callback? res, {status:200, content: resuilt}