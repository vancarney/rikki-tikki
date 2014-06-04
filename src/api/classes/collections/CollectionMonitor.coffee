{_}               = require 'underscore'
{ArrayCollection} = require 'js-arraycollection'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
Connection    = RikkiTikkiAPI.Connection
class CollectionMonitor extends RikkiTikkiAPI.base_classes.SingletonEmitter
  __polling_interval:10000
  __exclude:[/^_+.*$/, /^indexes+$/, /^migrations+$/]
  constructor:->
    CollectionMonitor.__super__.constructor.call @
    if (@__conn = RikkiTikkiAPI.getConnection())?
      @__db = @__conn.getMongoDB()
    else
      return throw 'database is not connected'
    @__collectionNames = new ArrayCollection []
    _initialized = false
    @__collectionNames.on 'collectionChanged', (data) =>
      type = 'changed'
      if !_initialized
        _initialized = true
        type = 'init'
      @emit type, data
    @refresh()
    @startPolling() if RikkiTikkiAPI.Util.Env.isDevelopment()
  filter:(value)->
    for item in @__exclude
      if (value.split('.').pop()).match item
        return true 
    return false
  refresh:(callback)->
    @__conn.getCollectionNames (e, names) =>
      ex = []
      if names?.length > 0
        list = _.compact _.map names, (v)=> name:(n=v.name.split '.').pop(), db:n.shift(), options: v.options if !@filter v.name
        _.each list, (val,key)=>
          ex.push val if 0 <= @getNames().indexOf val.name
        # find removed collections
        _.each (rm = _.difference @getNames(), _.pluck( list, 'name' )), (item)=>
          @__collectionNames.removeItemAt @getNames().indexOf item
        @__collectionNames.setSource list if (list = _.difference list, ex).length
      callback? e, list
  startPolling:(interval)->
    __polling_interval = interval if interval?
    @__iVal = setInterval (=> @refresh()), @__polling_interval
  stopPolling:->
    clearInterval @__iVal if @__iVal?
  getNames:->
    _.pluck @getCollections(), 'name'
  getCollections:->
    @__collectionNames.__list
  collectionExists:(name)->
    @getNames().lastIndexOf name > -1
CollectionMonitor.getInstance =->
  @__instance ?= new CollectionMonitor
module.exports = CollectionMonitor