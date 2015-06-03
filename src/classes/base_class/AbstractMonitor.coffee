{_}               = require 'lodash'
Util              = require '../utils'
Singleton         = require './Singleton'
ArrayCollection   = require 'js-arraycollection'
class AbstractMonitor extends Singleton
  __exclude:[]
  __iVal:null
  constructor:->
    AbstractMonitor.__super__.constructor.call @
    @__collection = new ArrayCollection []
    _initialized = false
    @__collection.on 'collectionChanged', (data) =>
      type = 'changed'
      if !_initialized
        # _initialized = true
        type = 'init'
      @emit type, data
    if Util.Env.isDevelopment()
      setTimeout (=>
        @refresh (e,list) => 
          _initialized = true
          @startPolling @__iVal
      ), 3
  filter:(value)=>
    if (type = typeof value) != 'string'
      throw "#{Util.Function.getConstructorName @}.filter expected value to be a string. Type was <#{type}>"
    for item in @__exclude
      return false if value.match item
    return true 
  refresh:(callback)->
    throw "#{Util.Function.getConstructorName @}.refresh(callback) is not implemented"
  startPolling:(interval)->
    @__polling_interval = interval if interval?
    @stopPolling()
    @__iVal = setInterval (=> @refresh()), @__polling_interval if @__polling_interval?
  stopPolling:->
    clearInterval @__iVal if @__iVal?
  getNames:->
    _.pluck @getCollection(), 'name'
  getCollection:->
    @__collection.__list
  getItemIdx:(name)->
    @getNames().lastIndexOf name
  itemExists:(name)->
    @getItemIdx(name) > -1
module.exports = AbstractMonitor