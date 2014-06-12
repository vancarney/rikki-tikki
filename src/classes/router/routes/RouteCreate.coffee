RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
class RouteCreate extends RikkiTikkiAPI.base_classes.AbstractRoute
  handler:(callback)->
    (req,res)=> 
      @handler.insert (e,result)=> 
        callback? res, if e? then e else result
module.exports = RouteCreate