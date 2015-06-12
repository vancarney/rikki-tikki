{_}               = require 'lodash'
Util              = require '../utils'
Document          = require './Document'
APIOptions        = require '../config/APIOptions'
DataSourceManager = require '../datasource/DataSourceManager'
class Collection extends Object
  constructor:(ref)->
    throw "collection reference must be defined" unless ref?
    _.extend @, ref
    @getCollection = (callback)=>
      return callback? 'Database is not connected', null unless @dataSource.connected
      @dataSource.ApiHero.getCollection @name, =>
        console.log arguments
        callback
    @
  # renames the referenced collection
  rename:(newName, opts, callback)->
    if typeof opts is 'function'
      callback = arguments[arguments.length - 1]
      opts = {}
    return callback "new name is required" unless newName? and typeof newName is 'string'
    @dataSource.ApiHero.renameCollection @name, newName, opts || {}, (e,ref)=>
      _.extend @, ref.s
      _args = arguments
      CollectionMonitor.getInstance().refresh =>
        callback.apply @, _args
  # drops the reference collection from the database
  drop:(callback)->
    @dataSource.ApiHero.dropCollection @name, =>
      (cm = CollectionMonitor.getInstance()).refresh (e,list)=>
        return callback e if e?
        if 0 <= _.pluck( cm.getCollection(), 'name').indexOf @name
          return callback "collection '#{@name}' not dropped" if col?
        callback null, true
  # scans the collection and derives a Schema Tree   
  getTree:(callback)->
    @dataSource.ApiHero.deriveSchema callback
    
Collection.create = (name, json, opts, callback)->
  throw 'callback required' unless arguments.length and typeof arguments[arguments.length - 1] is 'function'
  _cB = arguments[arguments.length - 1] 
  return _cB 'name is required' unless name? and typeof name is 'string'
  callback = =>
    _args = arguments
    CollectionMonitor.getInstance().refresh =>
      _cB.apply @, _args
  dsM = DataSourceManager.getInstance()
  dsName = if opts?.hasOwnProperty 'datasource' then opts.datasource else APIOptions.get('default_datasource') || null
  ds = dsM.getDataSource dsName
  return _cB "datasource '#{ds.name}' does not exist" unless ds?
  return _cB "datasource '#{ds.name}' is not configured for Api Hero" unless ds.ApiHero?
  ds.ApiHero.createCollection name, json, opts, (e,collection)=>
    return _cB "unable to create collection #{name}", null if e? or !collection
    callback.apply @, arguments
          
module.exports = Collection
CollectionMonitor = require './CollectionMonitor'
