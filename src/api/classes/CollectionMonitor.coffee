class RikkiTikkiAPI.CollectionMonitor extends EventEmitter
  constructor:(@__db, opts=interval:0)->
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
    @__db.collectionNames (e, names) =>
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
