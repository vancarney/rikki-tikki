class RikkiTikkiAPI.AbstractAdapter extends Object
  required:[]
  constructor:(@params)->
    _.each @required_params, (param)=>
      throw Error "required param '#{param}' was not defined in the adapter params object" if !@params.hasOwnProperty param
  addRoute:(route, handler)->