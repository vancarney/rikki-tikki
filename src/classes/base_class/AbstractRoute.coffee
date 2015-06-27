{_}               = require 'lodash'
{OperationTypes}  = require '../types'
Util              = require '../utils'
CollectionManager = require '../collections/CollectionManager'
# DSManager         = require '../datasource/DataSourceManager'
APIOptions        = require '../config/APIOptions'
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
    DSManager         = require '../datasource/DataSourceManager'
    dsm               = DSManager.getInstance()
    if 'AbstractRoute' == Util.Function.getConstructorName @ 
      throw 'AbstractRoute can not be directly instatiated\nhint: use a subclass instead.'
    # _db               = DSManager.getInstance().getDataSource()
    _getDS = (dsname)=>
      dsname = null unless typeof dsname is 'string'
      dsname ?= APIOptions.get 'default_datasource'
      ds = dsm.getDataSource dsname
    _collections      = CollectionManager.getInstance()
    _createCollection = (dsname, name, json, opts, callback)=>
      ds = _getDS dsname 
      ds.buildModel name, json, opts, (e, model)=>
        return callback e if e
        return callback 'unable to create model' unless model?
        model.create json || {}, opts || {}, arguments[arguments - 1]
    # ## Handler Object
    return (req,res)=>
      dsname = _getDS req.headers['DSNAME'] || null
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
          status  = 200
          content = if _.isArray(data.ops) and data.ops.length == 1 then data.ops[0] else data.ops
          # console.log content if (req.route.methods.get)?
          # status = 404 if (_.isArray(data.ops) and data.ops.length == 0) or typeof data.ops 'undefined'
          callback? null, {status:status, content: content}
      ## handler.find( callback )
      #> Performs query and object lookup in collection
      @handler.find = (query,callback)=>
        switch typeof query
          when 'object'
            q = query
          when 'string'
            q = JSON.parse query
          when 'function'
            q = {}
            callback = arguments[0]
          else
            return callback? 'unable to process query'
        # overwrites `q` with contents of Request Query
        q = req.query.where if req.query?.where
        # holds the cleaned up query if present
        where = if q? then @sanitize q else {}
        # attempts to access collection
        _collections.getCollection name, (e,col)=>
          # tests for collection result
          if col?
            # performs find operation and passes in generated callback handler
            col.find where, _callback callback
          else
            # tests if in Development Environment
            if Util.Env.isDevelopment()
              # if -1 is _collections.listCollections().indexOf name
              return callback?.apply @, [null, {status:200, content:[]}]
              # # attempts to create collection <name>
              # _createCollection name, (e,res)=>
                # # invokes callback and returns if error is set
                # return callback?.apply @, if e? then [{status:400, reason:e}, null] else [null, {status:200, content:{}}] 
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
        return callback? {status:400, reason:'required parameter `id` was not defined'} unless req.params.hasOwnProperty 'id'
        # attempts to access collection
        _collections.getCollection name, (e,col)=>
          return callback? {status:400, reason:"collecton `#{name}` was not defined"}, null unless col?
          # tests for collection result and performs findOne operation
          return col.findOne {_id: new ApiHero.getConnection().getTypes().ObjectId req.params.id}, (e,doc)=> 
            return callback? e, null if e?
            callback? null, { status: (if doc? then 200 else 404), content: doc }
          # tests if in Development Environment
          if Util.Env.isDevelopment()
            console.log 'about to create collection'
            # attempts to create collection <name>
            _createCollection dsname, name, (e,res)=>
              # invokes callback and returns if error is set
              return callback?.apply @, if e? then [{status:400, reason:e}, null] else [null, {status:404, content:{}}] 
          # invokes an error callback and return if above conditions were not met
          return callback? {status:400, reason:"Bad Request"}, null
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
            unless Util.Env.isProduction()
              req.on 'data', (b)=>
                # console.log b.toString 'utf8'
                data = JSON.parse b.toString 'utf8'
                if data? and (data = @sanitize data )?
                   _createCollection dsname, name, data, {idInjection: true}, (e,res)=>
                     # console.log res
                     return callback?.apply @, [null, {status:200, content:res}]
              # creates collection
              # _createCollection name, (e,res)=>
                # return callback? {status:400, reason:e}, null if e?
                # col.insert data, _callback callback
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
              delete data._id if data.hasOwnProperty '_id'
              # insures data is set and is consumable
              if (id = req.params.id)?
                col.update {_id: new ApiHero.getConnection().getTypes().ObjectId id}, {$set:data}, (e,num,rec)=>
                  return callback? {status:400, reason:e.message} if e?
                  callback? {status: 200, content:rec}
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
            col.remove {_id: new ApiHero.getConnection().getTypes().ObjectId req.params.id}, _callback callback
          else
            return callback? {status:400, reason:"Bad Request"}, null
      _.each @__before, (before,k)=> before req,res,data
      @handler(callback) req, res
  ## handler( callback )
  #> Abstract Handler Method
  #> Must be implemented by `subclass`
  handler:(callback)->
    throw "#{Util.Function.getConstructorName @}.handler(callback) is not implemented"
  ## sanitize( query )
  #> removes bad characters and reserved terms from passed object
  sanitize: (query)->
    filter  = null
    filtered = []
    restricted = []
    filter = _.partial _.without, _.keys query
    # remove each valid query operator from the query object keys
    _.each OperationTypes.query, (v)=> filtered = filter v
    _.each filtered, (v,k)=>
      # remove unknown/missapplied operators and restricted fields
      delete query[v] if (v.match /^\$/) or (0 <= restricted.indexOf v)
    query
  ## checkSchema( name )
  #> To be implemented
  checkSchema:(name)->
module.exports = AbstractRoute