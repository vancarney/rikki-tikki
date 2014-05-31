{_}               = require 'underscore'
{ArrayCollection} = require 'js-arraycollection'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
Connection    = RikkiTikkiAPI.Connection
class CollectionMonitor extends RikkiTikkiAPI.base_classes.SingletonEmitter
  __polling_interval:10000
  constructor:->
    # throw Error "CollectionMonitor requires a Connection as arg1. Type was '#{typeof @__conn}'" if !@__conn or !Util.isOfType @__conn, Connection
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
  refresh:(callback)->
    @__conn.getCollectionNames (e, names) =>
      if names?.length > 0
        list = _.compact _.map names, (v)-> name:(n=v.name.split '.').pop(), db:n.shift(), options: v.options if !v['name'].match /\.indexes+$/
        @__collectionNames.setSource list
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