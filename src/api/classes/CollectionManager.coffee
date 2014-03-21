Collection = require( 'mongoose' ).Collection
class RikkiTikkiAPI.CollectionManager extends EventEmitter
  constructor:(@__conn)->
    throw Error 'RikkiTikkiAPI.CollectionManager requires a RikkiTikkiAPI.Connection as arg1' if !@__conn
    throw Error "RikkiTikkiAPI.Connection arg1 must be RikkiTikkiAPI.Connection. Type was '#{typeof @__conn}'" if !RikkiTikkiAPI.Util.isOfType @__conn, RikkiTikkiAPI.Connection
    @__db = @__conn.getMongoDB() || throw Error 'RikkiTikkiAPI.Connection is broken'
    @refreshCollections()
  refreshCollections:(callback)->
    @__db.collectionNames (e, names) => 
      @__collectionNames = names if names?
      @emit 'changed'
      callback? e, @__collectionNames
  createCollection:(name, opts, callback)->
    callback ?= opts if typeof opts == 'function'
    if !@collectionExists name
      @__db.createCollection name, opts, (e,res)=>
        @refreshCollections()
        callback? e, res
  dropCollection:(name)->
    if @collectionExists name
      @__db[name].drop()
      @refreshCollections()
  renameCollection:(oldName, newName)->
    callback ?= opts if typeof opts is 'function'
    @__db[oldName].renameCollection newName if @collectionExists oldName
  getCollection:(name)->
    if @collectionExists() then @__db[name] else null
  collectionExists:(name)->
    @__db[name]?