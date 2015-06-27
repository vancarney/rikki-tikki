{_} = require 'lodash'
{EventEmitter}  = require 'events'
class SyncInstance extends EventEmitter
  constructor:(@kind,clazz)->
    throw 'kind is required' unless @kind
    throw "kind was required to be string type was #{_t}" unless (_t = typeof @kind) is 'string'
    throw 'clazz is required' unless clazz
    throw 'clazz must be instance of Singleton' unless clazz.getInstance? and typeof clazz.getInstance is 'function'
    @targetInstance = clazz.getInstance()
    .on 'init', => @onInit.apply @, arguments
    .on 'changed', => @onChanged.apply @, arguments
  # hanles `init` events
  onInit:(data)->
    # _added = arguments['0'].added
    # _syncInit() if ((_schemaInit = true) and _collectionInit) 
  # handles `changed` events  
  onChanged:(data)->
    _ops = []
    opTypes = _.keys data
    done = _.after opTypes.length, => @emit 'changed', _ops
    _.each opTypes, (operation)=>
      _.each data[operation], (item)=>
        _ops.push new SyncOperation @kind, item, operation 
        done()
module.exports = SyncInstance
SyncOperation = require './SyncOperation'
