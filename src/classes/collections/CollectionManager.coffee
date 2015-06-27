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
    throw "CollectionManager.createCollection: name is required" unless name and typeof name is 'string'
    if typeof opts is 'function'
      callback = arguments[arguments.length - 1]
      opts = {}
    if typeof json is 'function'
      callback = arguments[arguments.length - 1]
      json = {}
      opts = {}
    throw "CollectionManager.createCollection: callback is required" unless callback and typeof callback is 'function'
    @getCollection name, (e,col)=>
      return callback null, col if col?
      Collection.create name, json, opts, callback
  dropCollection:(name, callback)->
    throw 'callback required' unless typeof arguments[arguments.length - 1] is 'function'
    @getCollection name, (e,col)=>
      return callback.apply @, arguments if e?
      col.drop callback
          
  listCollections:(dsNames, callback)->
    throw 'CollectionManager.listCollections: callback required' unless typeof arguments[arguments.length - 1] is 'function'
    if typeof dsNames is 'function'
      callback  = arguments[0]
      dsNames   = [APIOptions.get 'default_datasource']
    dsNames = dsNames.split ',' if dsNames? and typeof dsNames is 'string'
    list = _.filter CollectionMonitor.getInstance().getCollection(), (v)=>
      0 <= dsNames.indexOf v.dsName
    callback null, list
    
  renameCollection:(name, newName, opts, callback)->
    if typeof opts is 'function'
      callback = arguments[arguments.length - 1]
      opts = {}
    _cB = ()=>
      # f = (itm)=>
        # console.log _.keys itm
        # itm.name is name
      # itm = _.find( @__monitor.__collection, f)
      # console.log itm
      # updated = _.clone itm
      # updated.name = newName
      # @__monitor.__collection.setItemAt updated, @__monitor.__collection.getItemIndex itm
      callback.apply @, arguments
    @getCollection name, (e,col)=>
      return callback.apply @, arguments if e?
      col.rename newName, opts, _cB
        
  getCollection:(name, callback)->
    throw "CollectionManager.getCollection: callback required" unless callback? and typeof callback is 'function'
    return callback "name required" unless name? and typeof name is 'string'
    return callback null, col[0] if (col = _.where @__monitor.getCollection(), name:name).length
    callback 'collection not found', null
    
module.exports = CollectionManager