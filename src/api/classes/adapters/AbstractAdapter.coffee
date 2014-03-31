class RikkiTikkiAPI.AbstractAdapter extends Object
  required:[]
  constructor:(@params)->
    _.each @required, (param)=>
      throw Error "required param '#{param}' was not defined in the adapter params object" if !@params[param]
  requestHandler:(req,res)->
  responseHandler:(req,res)->
  addRoute:(route, method, handler)->
