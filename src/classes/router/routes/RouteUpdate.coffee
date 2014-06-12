RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
class RouteUpdate extends RikkiTikkiAPI.base_classes.AbstractRoute
  handler:(callback)->   
    (req,res)=>
      @handler.update (e,result)=>
        callback? res, if e? then e else result
module.exports = RouteUpdate