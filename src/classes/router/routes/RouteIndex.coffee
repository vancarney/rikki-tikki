RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
class RouteIndex extends RikkiTikkiAPI.base_classes.AbstractRoute
  handler:(callback)->  
    (req,res)=>
      @handler.find (e,result)=>
        callback? res, if e? then e else result
module.exports = RouteIndex