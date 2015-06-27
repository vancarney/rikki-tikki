{_}               = require 'lodash'
Util              = require '../utils'
Document          = require './Document'
APIOptions        = require '../config/APIOptions'
class Collection extends Object
  'use strict'
  constructor:(ref)->
    throw "collection reference must be defined" unless ref?
    _.extend @, ref
    @getCollection = (callback)=>
      throw 'callback required' unless typeof arguments[arguments.length - 1] is 'function'
      return callback? 'Database is not connected', null unless @dataSource.connected
      @dataSource.getCollection @name, callback
    @
  # renames the referenced collection
  rename:(newName, opts, callback)->
    _cB = arguments[arguments.length - 1] 
    throw 'callback required' unless typeof _cB is 'function'
    callback = (e,col)=>
      _.extend @, col.s
      _cB.apply @, arguments
    opts = {} if typeof opts is 'function'
    @__renamedFrom = @name
    @dataSource.renameCollection @name, newName, opts, callback
    @name = newName
  # drops the reference collection from the database
  drop:(callback)->
    @dataSource.dropCollection @name, callback
  # scans the collection and derives a Schema Tree   
  getTree:(callback)->
    @dataSource.deriveSchema @name, callback
# creates new Collection on DataSource
Collection.create = (name, json, opts, callback)->
  _cB = arguments[arguments.length - 1] 
  throw 'callback required' unless typeof _cB is 'function'
  return _cB 'name is required' unless name? and typeof name is 'string'
  # callback = =>
    # _args = arguments
    # CollectionMonitor.getInstance().refresh =>
      # _cB.apply @, _args
  dsM = DataSourceManager.getInstance()
  dsName = if opts?.hasOwnProperty 'datasource' then opts.datasource else APIOptions.get('default_datasource') || null
  ds = dsM.getDataSource dsName
  return _cB "datasource '#{ds.name}' does not exist" unless ds?
  return _cB "datasource '#{ds.name}' is not configured for Api Hero" unless ds.isApiHeroEnabled()?
  # arguments[arguments.length - 1] = (e,collection)=>
    # return _cB "unable to create collection #{name}", null if e? or !collection
    # callback.apply @, arguments
  ds.createCollection.apply ds, arguments 
# exports Collection Class         
module.exports = Collection
CollectionMonitor = require './CollectionMonitor'
DataSourceManager = require '../datasource/DataSourceManager'