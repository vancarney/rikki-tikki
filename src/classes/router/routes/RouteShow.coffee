RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
class RouteShow extends RikkiTikkiAPI.base_classes.AbstractRoute
  handler:(callback)->   
    (req,res)=>
      @handler.show (e,result)=> 
        console.log result
        callback? res, if e? then e else result
module.exports = RouteShow