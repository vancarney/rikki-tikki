class RoutingParams extends Object
  constructor:(path, operation)->
    @setPath path if path
    @setOperation operation if operation
  setPath:(@path)->
    throw "Path was undefiend" unless @path
    # throw "Path was invalid" unless (@path.match /\/?[a-zA-Z]+\/+[\:a-zA-Z0-9]+\/\:?[A-Za-z_0-9]?\/?:?[a-zA-Z0-9\(\)]?/)?
  setOperation:(@operation)->
    switch @operation
      when 'index'
        @method = 'get'
      when 'show'
        @method = 'get'
      when 'update'
        @method = 'put'
      when 'create'
        @method = 'post'
      when 'destroy'
        @method = 'delete'
      else
        delete @operation
        throw 'Invalid REST Operation Type'
module.exports = RoutingParams