AbstractRoute = require '../../base_class/AbstractRoute'
class RouteCreate extends AbstractRoute
  handler:(callback)->
    (req,res)=>
      @handler.insert (e,result)=>
        callback? res, if e? then e else result
module.exports = RouteCreate