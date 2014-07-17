{_}               = require 'underscore'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
Connection    = RikkiTikkiAPI.Connection
class CollectionMonitor extends RikkiTikkiAPI.base_classes.AbstractMonitor
  __polling_interval:10000
  __exclude:[/^_+.*$/, /^indexes+$/, /^migrations+$/]
  constructor:->
    return throw 'database is not connected' if !(@__conn = RikkiTikkiAPI.getConnection())
    CollectionMonitor.__super__.constructor.call @
  refresh:(callback)->
    @__conn.getCollectionNames (e, names) =>
      ex = []
      if names?.length > 0
        list = _.compact _.map names, (v)=> 
          name:name, db:n.shift(), options: (v.options || {}) if @filter (name = (n=v.name.split '.').pop())
        _.each list, (val,key)=>
          ex.push val if 0 <= @getNames().indexOf val.name
        # find removed collections
        _.each (rm = _.difference @getNames(), _.pluck( list, 'name' )), (item)=>
          @__collection.removeItemAt @getNames().indexOf item
        @__collection.setSource list if (list = _.difference list, ex).length
      callback? e, list
module.exports = CollectionMonitor