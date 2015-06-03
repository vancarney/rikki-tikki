AbstractRoute = require '../../base_class/AbstractRoute'
class RouteUpdate extends AbstractRoute
  handler:(callback)->   
    (req,res)=>
      @handler.update (e,result)=>
        callback? res, if e? then e else result
module.exports = RouteUpdate