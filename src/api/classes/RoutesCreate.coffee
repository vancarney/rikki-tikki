class RikkiTikkiAPI.RoutesCreate extends Object
  constructor:(@__db, callback)->
    return (req,res)=>
      req.on 'data', (data)=> 
        d =  JSON.parse data
        @__db.getMongoDB().collection req.params.collection, (e,collection)=> 
          collection.insert d, (e,result)=>
            return callback? res, {status:500, content: 'failed to create record'} if e? and result[0]._id?
            return callback? res, {status:200, content: _id:result[0]._id}