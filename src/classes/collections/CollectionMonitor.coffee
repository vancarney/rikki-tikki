{_}               = require 'lodash'
async             = require 'async'
Util              = require '../utils'
AbstractMonitor   = require '../base_class/AbstractMonitor'
DataSourceManager = require '../datasource/DataSourceManager'
class CollectionMonitor extends AbstractMonitor
  # sets polling at 10s intervals
  __polling_interval:10000
  # excludes collections whose names match these values
  __exclude:[/^_+.*$/, /^indexes+$/, /^migrations+$/]
  constructor:->
    CollectionMonitor.__super__.constructor.call @
    setTimeout (=>
      if !_initialized
        _initialized = true
        @emit 'init', '0':'added':@getCollection()
    ), 600
  refresh:(callback)->
    throw 'callback required as arguments[0]' unless typeof callback is 'function'
    return callback 'unable to allocate DataSourceManager instance' unless (dsm = DataSourceManager.getInstance())?
    list = []
    async.forEachOf dsm.getDSNames(), ((dsName, k, cB)=>
      if (ds = dsm.getDataSource dsName)?
        # maps list with objects derived from our collection info
        list = _.flatten list.concat _.compact _.map ds.listCollections(), (n)=> 
          name:name, dsName:dsName, dataSource: ds if @filter (name = n.split('.').pop())
      # invokes async iterator callback
      cB()
    ), (e)=>
      ex = []
      # filters out existing collections
      for val in list
        ex.push val if 0 <= @getNames().indexOf val.name
      # finds removed collections
      for item in (rm = _.difference @getNames(), _.pluck list, 'name' )
        @__collection.removeItemAt @getNames().indexOf item
      # resets with new collections added to the list
      @__collection.setSource list if (list = _.difference list, ex).length
      callback @, unless e? then [null, list] else [e]
module.exports = CollectionMonitor
Fleek = require '../..'
DSManager = require '../datasource/DataSourceManager'