class RikkiTikkiAPI.AbstractAdapter extends Object
  required:[]
  constructor:(@params)->
    _.each @required, (param)=>
      throw Error "required param '#{param}' was not defined in the adapter params object" if !@params[param]
  addRoute:(route, method, handler)->
  router:-> null