{_}             = require 'underscore'
RikkiTikkiAPI   = module.parent.exports.RikkiTikkiAPI
Env             = RikkiTikkiAPI.Util.Env
class AbstractRoute extends Object
  __before: null
  __after: null
  ## addBeforeHandler( function )
  #> Pushes callback functions to be performed BEFORE the request is performed against the collection
  addBeforeHandler:(fn)->
    throw "Param must be of type 'function' param was Type <#{typeof fn}>" if typeof fn != 'function'
    @__before ?= []
    @__before.push fn
  ## addAfterHandler( function )
  #> Pushes callback functions to be performed AFTER the request is performed against the collection
  addAfterHandler:(fn)->
    throw "Param must be of type 'function' param was Type <#{typeof fn}>" if typeof fn != 'function'
    @__after ?= []
    @__after.push fn
  constructor:(callback)->
    if 'AbstractRoute' == RikkiTikkiAPI.Util.Function.getConstructorName @ 
      throw 'AbstractRoute can not be directly instatiated\nhint: use a subclass instead.'
    _db               = RikkiTikkiAPI.getConnection()
    _collections      = RikkiTikkiAPI.getCollectionManager()
    _createCollection = (name, callback)->
      _collections.createCollection name, {}, (e,collection)=>
        callback? e, collection
    ## Handler Object
    return (req,res)=>
      # references the colleciton name from the request params
      name = req.params.collection
      # wraps the passed callback into a handler
      _callback = (callback)=>
        # accepts error and data objects
        (e,data)=>
          # invokes callback if error is set
          return callback? e, null if e?
          # loops on the __after array if it has elements
          _.each @__after, (after,k)=> 
            # calls `after` handlers to post-process the data
            after req, res, data
          # invokes callback with final data representation
          callback? null, {status:200, content: if _.isArray(data.ops) and data.ops.length == 1 then data.ops[0] else data.ops}
      ## handler.find( callback )
      #> Performs query and object lookup in collection
      @handler.find = (callback)=>
        # holds the cleaned up query if present
        where = @sanitize JSON.parse req.query.where || "{}"
        # attempts to access collection
        _collections.getCollection name, (e,col)=>
          # tests for collection result
          if col?
            # performs find operation and passes in generated callback handler
            col.find where, _callback callback
          else
            console.log "isDevelopment: #{Env.isDevelopment()}"
            # tests if in Development Environment
            if Env.isDevelopment()
              # attempts to create collection <name>
              _createCollection name, (e,res)=>
                # invokes callback and returns if error is set
                return callback?.apply @, if e? then [{status:400, reason:e}, null] else [null, {status:200, content:{}}] 
            else
              # we should not ever get here, so invoke an error callback and return
              return callback? {status:400, reason:"Bad Request"}, null
      ## handler.list( callback )
      #> Handles index requests
      @handler.list = (callback)=>
        @handler.find {}, _callback callback
      ## handler.show( callback )
      #> Handles show requests
      @handler.show = (callback)=>
        @handler.find {_id:req.params.id}, _callback callback
      ## handler.insert( callback )
      #> Handles index requests
      @handler.insert = (callback)=>
        _collections.getCollection name, (e,col)=>
          # tests for collection
          if col?
            # handles data in request body
            req.on 'data', (b)=>
              data = JSON.parse b.toString 'utf8'
              if data? and (data = @sanitize data )?
                col.insert data, _callback callback 
              else
                callback? {status:400, reason:"Bad Request"}, null
          else
            if Env.isDevelopment()
              # creates collection
              _createCollection name, (e,res)=>
                return callback? {status:400, reason:e}, null if e?
                col.insert data, _callback callback
            else
              # invokes an error callback and returns
              return callback? {status:400, reason:"Bad Request"}, null
      ## handler.update( callback )
      #> Handles update requests
      @handler.update = (callback)=>
        _collections.getCollection name, (e,col)=>
          if col?
            # listens for incoming data
            req.on 'data', (b)=>
              data = JSON.parse b.toString 'utf8'
              # insures data is set and is consumable
              if (id = req.params.id)? and data? and (data = @sanitize data )?
                col.update {_id:id}, data, _callback callback
              else
                callback? {status:400, reason:"Bad Request"}, null
          else
            return callback? {status:400, reason:"Bad Request"}, null
      ## handler.destroy( callback )
      #> Handles destroy requests
      @handler.destroy = (callback)=>
        # objectID, 
        _collections.getCollection name, (e,col)=>
          if col?
            col.destroy {_id:req.params.id}, _callback callback
          else
            return callback? {status:400, reason:"Bad Request"}, null
      _.each @__before, (before,k)=> before req,res,data
      @handler(callback) req, res
  ## handler( callback )
  #> Abstract Handler Method
  #> Must be implemented by `subclass`
  handler:(callback)->
    throw "#{RikkiTikkiAPI.Util.Function.getConstructorName @}.handler(callback) is not implemented"
  ## sanitize( query )
  #> removes bad characters and reserved terms from passed object
  sanitize: (query)->
    filter  = null
    filtered = []
    restricted = []
    filter = _.partial _.without, _.keys query
    # remove each valid query operator from the query object keys
    _.each RikkiTikkiAPI.OperationTypes.query, (v)=> filtered = filter v
    _.each filtered, (v,k)=>
      # remove unknown/missapplied operators and restricted fields
      delete query[v] if (v.match /^\$/) or (0 <= restricted.indexOf v)
    query
  ## checkSchema( name )
  #> To be implemented
  checkSchema:(name)->
module.exports = AbstractRoute