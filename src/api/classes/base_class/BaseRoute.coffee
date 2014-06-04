RikkiTikkiAPI     = module.parent.exports.RikkiTikkiAPI
CollectionManager = {}
class BaseRoute extends Object
  addBeforeHandler:(fn)->
    throw "Param must be of type 'function' param was #{typeof fn}" if typeof fn == false
    @before ?= []
    @before.push fn
  addAfterHandler:(fn)->
    throw "Param must be of type 'function' param was #{typeof fn}" if typeof fn == false
    @after ?= []
    @after.push fn
  constructor:->
    @__db = RikkiTikkiAPI.getConnection()
    CollectionManager = RikkiTikkiAPI.getCollectionManager()
  createCollection:(name, callback)->
    if BaseRoute.isDevelopment() and !BaseRoute.collectionExists name
      CollectionManager.createCollection name, {}, (e,res)=>
        RikkiTikkiAPI.getSchemaManager().createSchema name, {}, (e,res)=>
          RikkiTikkiAPI.getSchemaTreeManager().createTree name, {}, (e,res)=>
            callback? e, res
  checkSchema:(name)->
BaseRoute.isDevelopment = ->
  RikkiTikkiAPI.Util.Env.isDevelopment()
BaseRoute.collectionExists = (name)->
  0 <= RikkiTikkiAPI.listCollections().indexOf name
module.exports = BaseRoute   
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