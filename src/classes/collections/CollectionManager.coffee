{_}               = require 'lodash'
Util              = require '../utils'
Singleton         = require '../base_class/Singleton'
APIOptions        = require '../config/APIOptions'
# DSManager         = require '../datasource/DataSourceManager'
Collection        = require './Collection'
CollectionMonitor = require './CollectionMonitor'
class CollectionManager extends Singleton
  constructor:->
    # @__ds = DSManager.getInstance()
    @__monitor = CollectionMonitor.getInstance()
    
  # _obtainDataSource:(name,callback)->
    # if name? and typeof name is 'function'
      # callback = arguments[0]
      # name = null
    # throw 'callback is required' unless callback? and typeof callback is 'function'
    # if (ds = @__ds.getDataSource name || null)?
      # return callback null, ds
    # callback "unable to obtain datasource '#{opts.datasource}"
    
  createCollection:(name, json, opts, callback)->
    Collection.create.apply @, arguments
       
  dropCollection:(name, callback)->
    throw 'callback required' unless arguments.length and typeof arguments[arguments.length - 1] is 'function'
    _cB = arguments[arguments.length - 1]
    return _cB 'name is required' unless name? and typeof name is 'string'
    arguments[arguments.length - 1] = =>
      _args = arguments
      CollectionMonitor.getInstance().refresh =>
        _cB.apply @, _args
    @getCollection name, (e,col)=>
      return _cB.apply @, arguments if e?
      col.drop (e,c)=>
        return callbak e if e?
        @__monitor.refresh =>
          callback e, true
          
  listCollections:(dsNames, callback)->
    throw 'callback required' unless arguments.length and typeof arguments[arguments.length - 1] is 'function'
    if typeof dsNames is 'function'
      callback = arguments[0]
      dsNames = [APIOptions.get 'default_datasource']
    dsNames = dsNames.split ',' if dsNames? and typeof dsNames is 'string'
    list = _.filter CollectionMonitor.getInstance().getCollection(), (v)=>
      0 <= dsNames.indexOf v.dsName
    callback null, list
    
  renameCollection:(name, newName, opts, callback)->
    throw 'callback required' unless arguments.length and typeof arguments[arguments.length - 1] is 'function'
    _cB = arguments[arguments.length - 1]
    return _cB 'name is required' unless name? and typeof name is 'string'
    if typeof opts is 'function'
      opts = {}
    callback = =>
      _args = arguments
      CollectionMonitor.getInstance().refresh =>
        _cB.apply @, _args
    @getCollection name, (e,col)=>
      col.rename newName, opts || {}, (e, res)=>
        return _cB.apply @, arguments if e?
        callback.apply @, arguments
        
  getCollection:(name, callback)->
    throw "callback required" unless callback? and typeof callback is 'function'
    return callback null, col[0] if (col = _.where @__monitor.getCollection(), name:name).length
    callback 'collection not found'
    
module.exports = CollectionManager