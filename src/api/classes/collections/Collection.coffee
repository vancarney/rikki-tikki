RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
class Collection extends Object
  constructor:(@__collection)->
    throw "collection instance must be defined" if typeof @__collection == 'undefined' or @__collection == null
  drop:(callback)->
    @__collection.drop callback
  indexes:(callback)->
    @__collection.indexes callback
  createIndex:(name,opts={},callback)->
    if typeof opts == 'function'
      callback = opts
      opts = null
    @__collection.createIndex name, opts, callback 
  ensureIndex:(name,opts={},callback)->
    if typeof opts == 'function'
      callback = opts
      opts = null
    @__collection.ensureIndex name, opts, callback  
  dropIndex:(name, callback)->
    throw "can not drop index on _id field" if name == '_id'
    @__collection.dropIndex name, callback
  dropAllIndexes:(callback)->
    @__collection.dropIndexes callback
  indexExists:(indexNames,callback)->
    @__collection.indexExists indexNames, callback 
  indexInformation:(opts={},callback)->
    if typeof opts == 'function'
      callback = opts
      opts = null
    @__collection.indexInformation opts, callback    
  find:(params, opts, callback)->
    params = Util.stripNull params
    @__collection params, opts, callback
  insert:(data, opts={}, callback)->
    @upsert data, opts, callback
  save:(data, opts={}, callback)->
    @upsert data, opts, callback
  update:(data, opts={}, callback)->
    @__collection.insert data, opts, callback
  upsert:(data, opts={}, callback)->
    opts.upsert = true
    @update data, opts, callback
  show:->
  rename:(name, opts,callback)->
    if typeof opts == 'function'
      callback = opts
      opts = null
    @__collection.rename name, opts, callback
  remove:(query, opts={}, callback)->
    @__collection.remove query, opts, callback
  destroy:(id, callback)->
    @remove {_id:id}, null, callback
module.exports = Collection