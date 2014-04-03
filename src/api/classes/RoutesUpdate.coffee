class RikkiTikkiAPI.RoutesUpdate extends Object
  constructor:(@__db, callback)->
    return (req,res)=>
      req.on 'data', (data)=> 
        d =  JSON.parse data
        @__db.getMongoDB().collection req.params.collection, (e,collection)=> 
          delete d._id if d._id?
          collection.update {_id:req.params.id}, {$set:d}, (e,result)=>
            return callback? res, {status:500, content: 'failed to execute query'} if e?
            return callback? res, {status:204, content: ''}