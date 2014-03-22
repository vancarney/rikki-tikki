class RikkiTikkiAPI.CollectionManager extends EventEmitter
  constructor:(@__conn)->
    throw Error 'RikkiTikkiAPI.CollectionManager requires a RikkiTikkiAPI.Connection as arg1' if !@__conn
    throw Error "RikkiTikkiAPI.Connection arg1 must be RikkiTikkiAPI.Connection. Type was '#{typeof @__conn}'" if !RikkiTikkiAPI.Util.isOfType @__conn, RikkiTikkiAPI.Connection
    @__db = @__conn.getMongoDB() || throw Error 'RikkiTikkiAPI.Connection is broken'
  createCollection:(name, opts, callback)->
    callback ?= opts if typeof opts == 'function'
    @__db.createCollection name, opts, (e,collection)=>
      callback? e, collection
  dropCollection:(name, callback)->
    @getCollection name, (e,collection)=>
      collection.drop (e, res)=>
        callback? e, collection
  renameCollection:(oldName, newName, callback)->
    @getCollection oldName, (e,collection)=> 
      collection.rename newName, dropTarget:true, (e, res)=> 
        callback? e, res
  getCollection:(name, callback)->
    @__db.collection name, (e,collection)=> callback? e, collection