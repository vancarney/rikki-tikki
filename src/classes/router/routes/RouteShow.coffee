AbstractRoute = require '../../base_class/AbstractRoute'
class RouteShow extends AbstractRoute
  handler:(callback)->   
    (req,res)=>
      @handler.show (e,result)=> 
        callback? res, if e? then e else result
module.exports = RouteShow