{_}               = require 'lodash'
Util              = require '../utils'
Singleton         = require '../base_class/Singleton'
APIOptions        = require '../config/APIOptions'
Collection        = require './Collection'
CollectionMonitor = require './CollectionMonitor'
class CollectionManager extends Singleton
  constructor:->
    @__monitor = CollectionMonitor.getInstance()

  createCollection:(name, json, opts, callback)->
    Collection.create.apply @, arguments
       
  dropCollection:(name, callback)->
    throw 'callback required' unless typeof arguments[arguments.length - 1] is 'function'
    @getCollection name, (e,col)=>
      return callback.apply @, arguments if e?
      col.drop callback
          
  listCollections:(dsNames, callback)->
    throw 'callback required' unless typeof arguments[arguments.length - 1] is 'function'
    if typeof dsNames is 'function'
      callback  = arguments[0]
      dsNames   = [APIOptions.get 'default_datasource']
    dsNames = dsNames.split ',' if dsNames? and typeof dsNames is 'string'
    list = _.filter CollectionMonitor.getInstance().getCollection(), (v)=>
      0 <= dsNames.indexOf v.dsName
    callback null, list
    
  renameCollection:(name, newName, opts, callback)->
    @getCollection name, (e,col)=>
      return callback.apply @, arguments if e?
      col.rename newName, opts, callback
        
  getCollection:(name, callback)->
    throw "callback required" unless callback? and typeof callback is 'function'
    return callback "name required" unless name? and typeof name is 'string'
    return callback null, col[0] if (col = _.where @__monitor.getCollection(), name:name).length
    callback 'collection not found'
    
module.exports = CollectionManager