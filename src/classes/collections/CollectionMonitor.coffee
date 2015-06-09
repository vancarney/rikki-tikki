{_}               = require 'lodash'
# async             = require 'async'
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
    dsm = DataSourceManager.getInstance()
    names = dsm.getDSNames()
    list = []
    done = _.after names.length, =>
      ex = []
      # filters out existing collections
      for val in list
        ex.push val if 0 <= @getNames().indexOf val.name
      # finds removed collections
      for item in (rm = _.difference @getNames(), _.pluck list, 'name' )
        @__collection.removeItemAt @getNames().indexOf item
      # resets with new collections added to the list
      @__collection.setSource list if (list = _.difference list, ex).length
      callback? @, unless e? then [null, list] else [e]
    for dsName in names
      if (ds = dsm.getDataSource dsName)?
        ds.listCollections (e,cols)=>
          return callback e if e?
          # maps list with objects derived from our collection info
          list = _.flatten list.concat _.compact _.map cols, (n)=> 
            name:name, dsName:dsName, dataSource: ds if @filter (name = n.split('.').pop())
          done()

module.exports = CollectionMonitor
DSManager = require '../datasource/DataSourceManager'