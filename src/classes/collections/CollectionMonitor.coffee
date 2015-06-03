{_}               = require 'lodash'
Util              = require '../utils'
AbstractMonitor   = require '../base_class/AbstractMonitor'
class CollectionMonitor extends AbstractMonitor
  # sets polling at 10s intervals
  __polling_interval:10000
  # excludes collections whose names match these values
  __exclude:[/^_+.*$/, /^indexes+$/, /^migrations+$/]
  constructor:(dsName)->
    return throw 'datasource required' unless @__ds = DSManager.getInstance().getDataSource dsName
      
    CollectionMonitor.__super__.constructor.call @
    setTimeout (=>
      if !_initialized
        _initialized = true
        @emit 'init', '0':'added':@getCollection()
    ), 600
  refresh:(callback)->
    DataSourceManager = require '../datasource/DataSourceManager'
    dsm = DataSourceManager.getInstance()
    _.each dsm.getDSNames(), (dsName)=>
      console.log dsName
      # console.log "dsName: #{dsName}"
      dsm.getDataSource dsName, (e, conn)=>
        conn.listCollections (e, names) =>
          ex = []
          if names?
            # maps list with objects derived from our collection info
            list = _.compact _.map names, (v)=> 
              name:name, db:n.shift(), options: (v.options || {}) if @filter (name = (n=v.name.split '.').pop())
            _.each list, (val,key)=>
              # filters out existing collections
              ex.push val if 0 <= @getNames().indexOf val.name
            # finds removed collections
            _.each (rm = _.difference @getNames(), _.pluck( list, 'name' )), (item)=>
              @__collection.removeItemAt @getNames().indexOf item
            # adds new collections to the list
            @__collection.setSource list if (list = _.difference list, ex).length
          # invokes callback if defined
          callback? e, list
module.exports = CollectionMonitor
Fleek = require '../..'
DSManager         = require '../datasource/DataSourceManager'