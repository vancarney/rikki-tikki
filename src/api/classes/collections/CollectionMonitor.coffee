{_}             = require 'underscore'
RikkiTikkiAPI = module.parent.exports.RikkiTikkiAPI
Util          = RikkiTikkiAPI.Util
Connection    = RikkiTikkiAPI.Connection
EventEmitter    = require('events').EventEmitter
ArrayCollection = require('js-arraycollection').ArrayCollection
class CollectionMonitor extends EventEmitter
  constructor:(@__conn, opts=interval:0)->
    throw Error 'CollectionMonitor requires a Connection as arg1' if !@__conn
    throw Error "CollectionMonitor arg1 must be Connection. Type was '#{typeof @__conn}'" if !Util.isOfType @__conn, Connection
    @__db = @__conn.getMongoDB()
    @__collectionNames = new ArrayCollection []
    _initialized = false
    @__collectionNames.on 'collectionChanged', (data) =>
      type = 'changed'
      if !_initialized
        _initialized = true
        type = 'init'
      @emit type, data
    @refresh()
    @start opts.interval if opts.interval? and opts.interval > 0
  refresh:(callback)->
    @__conn.getCollectionNames (e, names) =>
      if names?.length > 0
        @__collectionNames.setSource list = _.map names, (v)-> name:v['name']
      callback? e, list
  start:(interval=20)->
    @__iVal = setInterval (=> @refresh()), interval
  stop:->
    clearInterval @__iVal if @__iVal?
  getNames:->
    _.pluck @getCollections(), 'name'
  getCollections:->
    @__collectionNames.__list
  collectionExists:(name)->
    @getNames().lastIndexOf name > -1
module.exports = CollectionMonitor