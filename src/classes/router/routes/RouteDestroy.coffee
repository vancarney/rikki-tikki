AbstractRoute = require '../../base_class/AbstractRoute'
class RouteDestroy extends AbstractRoute
  handler:(callback)->   
    (req,res)=>
      @handler.destroy (e,result)=>
        callback? res, if e? then e else result
module.exports = RouteDestroy