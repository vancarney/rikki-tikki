{_}           = require 'underscore'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
class Collection extends Object
  constructor:(@name)->
    throw "collection name must be defined" if !@name
    Object.freeze @
  getCollection: (callback)=>
    if (_db = RikkiTikkiAPI.getConnection())?
      _db.getMongoDB().collection @name, (e,collection)=> callback? e, collection
    else
      callback? 'Database is not connected', null
  drop:(callback)->
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.drop callback
  indexes:(callback)->
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.indexes callback
  createIndex:(name,opts={},callback)->
    if typeof opts == 'function'
      callback = opts
      opts = null
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.createIndex name, opts, callback 
  ensureIndex:(name,opts={},callback)->
    if typeof opts == 'function'
      callback = opts
      opts = null
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.ensureIndex name, opts, callback  
  dropIndex:(name, callback)->
    throw "can not drop index on _id field" if name == '_id'
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.dropIndex name, callback
  dropAllIndexes:(callback)->
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.dropIndexes callback
  indexExists:(indexNames,callback)->
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.indexExists indexNames, callback 
  indexInformation:(opts={},callback)->
    if typeof opts == 'function'
      callback = opts
      opts = null
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.indexInformation opts, callback 
  _sanitize:(params)->
    Util.String.stripNull if typeof params == 'string' then params else JSON.stringify params   
  find:(params, opts, callback)->
    if typeof opts == 'function'
      callback = arguments[1]
      opts = null
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.find @_sanitize(params), callback
  insert:(params, opts={}, callback)->
    @upsert @_sanitize(params), opts, callback
  save:(params, opts={}, callback)->
    @upsert @_sanitize(params), opts, callback
  update:(params, opts={}, callback)->
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.insert @_sanitize(params), opts, callback
  upsert:(params, opts={}, callback)->
    opts.upsert = true
    @update @_sanitize(params), opts, callback
  show:(callback)->
    @find {}, {}, callback
  rename:(name, opts,callback)->
    if typeof opts == 'function'
      callback = opts
      opts = null
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.rename name, opts, callback
  remove:(query, opts={}, callback)->
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.remove query, opts, callback
  destroy:(id, callback)->
    @remove {_id:id}, null, callback
  getTree:->
    tree = {}
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.find {}, (e,res)=>
        return [] if e? or !res.length
        _.each res, (v,k)=>
          _.extend tree, (new Document v).serialize()
    return tree          
module.exports = Collection