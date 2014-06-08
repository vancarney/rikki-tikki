{_}                           = require 'underscore'
RikkiTikkiAPI                 = module.parent.exports.RikkiTikkiAPI || module.parent.exports
# module.exports.RikkiTikkiAPI  = RikkiTikkiAPI
# SchemaTreeManager             = require '../schema_tree/SchemaTreeManager'
class AbstractRoute extends Object
  __before: null
  __after: null
  addBeforeHandler:(fn)->
    throw "Param must be of type 'function' param was Type <#{typeof fn}>" if typeof fn != 'function'
    @__before ?= []
    @__before.push fn
  addAfterHandler:(fn)->
    throw "Param must be of type 'function' param was Type <#{typeof fn}>" if typeof fn != 'function'
    @__after ?= []
    @__after.push fn
  constructor:(callback)->
    if (RikkiTikkiAPI.Util.Function.getFunctionName arguments.callee.caller.__super__.constructor ) != 'AbstractRoute'
      return throw "AbstractRoute can not be directly instatiated. Use a subclass instead."
    @__db           = RikkiTikkiAPI.getConnection()
    @__collections  = RikkiTikkiAPI.getCollectionManager()
    return (req,res)=>
      # @__before
      @handler(callback) req, res
      # @__after
  handler:(callback)->
    throw "#{RikkiTikkiAPI.Util.Function.getConstructorName @}.handler(callback) is not implemented" 
  sanitize: (query)->
    filter  = null
    filtered = []
    restricted = []
    filter = _.partial _.without, _.keys query
    # remove each valid query operator from the query object keys
    _.each RikkiTikkiAPI.OperationTypes.query, (v)=> filtered = filter v
    _.each filtered, (v,k)=>
      # remove unknown or missapplied operators
      delete query[v] if v.match /^\$/
      # remove restricted fields
      delete query[v] if restricted.indexOf v >= 0
    query
  createCollection:(name, callback)->
    if AbstractRoute.isDevelopment() and !AbstractRoute.collectionExists name
      console.log "creating collection #{name}"
      @__collections.createCollection name, {}, (e,res)=>
        RikkiTikkiAPI.getSchemaManager().createSchema name, {}, (e,res)=>
          RikkiTikkiAPI.getSchemaTreeManager().createTree name, {}, (e,res)=>
            callback? e, res
  checkSchema:(name)->
AbstractRoute.isDevelopment = ->
  RikkiTikkiAPI.Util.Env.isDevelopment()
AbstractRoute.collectionExists = (name)->
  0 <= RikkiTikkiAPI.listCollections().indexOf name
module.exports = AbstractRoute
###
    if obj.before
      path = "#{@__api_path}/:collection/:id"
      app.all path, obj.before
      verbose && logger?.log 'debug', "     ALL #{path} -> before" 
      path = "#{@__api_path}/:collection/:id/*"
      app.all path, obj.before
      verbose && logger?.log 'debug', "     ALL #{path} -> before" 

    if obj.after
      path = "#{@__api_path}/:collection/:id"
      app.all path, obj.after
      verbose && logger?.log 'debug', "     ALL #{path} -> after" 
      path = "#{@__api_path}/:collection/:id/*"
      app.all path, obj.after
      verbose && logger?.log 'debug', "     ALL #{path} -> after" 
###