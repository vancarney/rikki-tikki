AbstractRoute = require '../../base_class/AbstractRoute'
class RouteIndex extends AbstractRoute
  handler:(callback)->  
    (req,res)=>
      @handler.find (e,result)=>
        callback? res, if e? then e else result
module.exports = RouteIndex