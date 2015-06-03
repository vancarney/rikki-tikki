{_}               = require 'lodash'
Util              = require '../utils'
class Collection extends Object
  constructor:(@name, @ds)->
    throw "collection name must be defined" if !@name
    @getCollection = (callback)=>
      return callback? 'Database is not connected', null unless @ds.collection?
      @ds.collection @name, (e,collection)=>
        callback? e, collection
    Object.freeze @
    @
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
  _sanitize: (params)-> params
  find:(params, opts, callback)->
    # return error if params argument is empty
    return callback? 'argument `params` required', null unless params
    # return error if params argument is not an object
    return callback? 'argument `params` expected type `object` type was #{typeof params}', null unless typeof params is 'object'
    # tests if opts is a function
    if typeof opts == 'function'
      # assigns callback to opts params
      callback = arguments[1]
      # assigns opts argument
      opts = {}
    # assigns opts argument if unassigned
    opts ?= {}
    # attempts to retrieve collection
    @getCollection (e,col) =>
      # returns callback with error if error is present
      return callback? e, null if e?
      # performs find operation
      col.find @_sanitize( params ), {}, (e, res)=> res.toArray callback    
  findOne:(params, opts, callback)->
    # return error if params argument is empty
    return callback? 'argument `params` required', null unless params
    # return error if params argument is not an object
    return callback? 'argument `params` expected type `object` type was #{typeof params}', null unless typeof params is 'object'
    # tests if opts is a function
    if typeof opts == 'function'
      # assigns callback to opts params
      callback = arguments[1]
      # assigns opts argument
      opts = {}
    # assigns opts argument if unassigned
    opts ?= {}
    # attempts to retrieve collection
    @getCollection (e,col) =>
      # returns callback with error if error is present
      return callback? e, null if e?
      # performs find operation
      col.findOne @_sanitize( params ), opts, callback
  insert:(params, opts={}, callback)->
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.insert params, opts, callback
  save:(params, opts={}, callback)->
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.save params, opts, callback
  update:(params, opts={}, callback)->
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.update params, opts, callback
  upsert:(params, opts={}, callback)->
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.upsert params, opts, callback
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
  getTree:(callback)->
    types = {}
    tree = {}
    compare = (a, b)->
      return 1 if (a[1] < b[1] )
      return -1 if (a[1] > b[1])
      0
    @getCollection (e,col) =>
      return callback? e, null if e?
      col.find {}, {}, (e,res)=>
        return callback? e if e?
        res.toArray (e,arr)=>
          for record in arr
            branch = (new Document record).serialize()
            for key,value of branch
              types[key] ?= {}
              types[key][value] = if types[key][value]? then types[key][value] + 1 else 1
          for field, type of types
            tPair = _.pairs type
            if tPair.length > 1
              tPair.sort compare
              type = if ((tPair[0][1]/tPair[1][1])*100 > 400) then tPair[0][0] else 'Mixed'
            else
              type = tPair[0][0]
            tree[field] = type
          return callback? null, tree
          
Collection.create = (name, ds, json, opts, callback)->
  if typeof opts is 'function'
    callback = arguments[2]
    opts = null
  ds.createCollection name, json, opts, (e,collection)=>
    if collection # != undefined and collection?
      return callback? null, new Collection name, ds
    else
      callback? "unable to create collection #{name}", null
      
Collection.build = (name, ds, json, opts, callback)->
  if typeof opts is 'function'
    callback = arguments[2]
    opts = null
  ds.buildCollection name, json, opts, (e,collection)=>
    if collection # != undefined and collection?
      return callback? null, new Collection name, ds
    else
      callback? "unable to create collection #{name}", null
module.exports = Collection
Document       = require './Document'