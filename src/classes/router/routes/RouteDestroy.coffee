RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
class RouteDestroy extends RikkiTikkiAPI.base_classes.AbstractRoute
  handler:(callback)->   
    (req,res)=>
      @handler.destroy (e,result)=>
        callback? res, if e? then e else result
module.exports = RouteDestroy