{_}       = require 'lodash'
Util      = require '../utils'
{EventEmitter} = require 'events'
Singleton = require '../base_class/Singleton'
class SyncService extends Singleton
  constructor:->
    __syncItems = {}
    __typeDelegates = {} 
    __changeHandler = (ops)=>
      _.each ops, (op)=>
        __typeDelegates[op.kind].emit op.operation, op.data
    @registerSyncInstance = (kind,item)=>
      return if @hasKind kind
      __typeDelegates[kind] = new EventEmitter
      __typeDelegates[kind].off = (event, listener)=>
        __typeDelegates[kind].removeListener event, listener
      (__syncItems[kind] = item).on 'changed', __changeHandler
      @ 
    @removeSyncInstance = (kind)=>
      return unless @hasKind kind
      __syncItems[kind].off 'changed', __changeHandler
      delete __syncItems[kind]
      __typeDelegates[kind].removeAllListeners()
      @
    @addSyncHandler = (kind,type,handler)=>
      __typeDelegates[kind]?.on type, handler
      @
    @removeSyncHandler = (kind,type,handler)=>
      __typeDelegates[kind]?.off type, handler
      @
    @listSyncKinds = =>
      _.keys __syncItems
    @hasKind = (kind)=>
      0 <= @listSyncKinds().indexOf kind
module.exports = SyncService
module.exports.SyncInstance  = require './SyncInstance'
module.exports.SyncOperation = require './SyncOperation'