EventEmitter        = require 'events'
SyncService         = require '../src/classes/services/SyncService'
global.api_options  = require '../src/classes/config/APIOptions'

  
class MockApp extends EventEmitter
  listModules: -> []
  SyncService: SyncService
  options:
    moduleOptions:{}
  getModuleConfigs: ->
      [
        setting: 'blah'
      ]
  createSyncInstance: (name,clazz)=>
    SyncService.getInstance().registerSyncInstance name, new SyncService.SyncInstance name, clazz
  destroySyncInstance: (name)=>
    SyncService.getInstance().removeSyncInstance name
global.app =
  set: ->
  get: -> true
  use: ->
  engine: -> {}
  datasources: 
    db:
      connector: 'memory'
  once: (name, callback)->
    callback(null, true)
  # ApiHero: new MockApp
mockApp = ->
mockApp.set  = ->
mockApp.get  = ->
mockApp.put  = ->
mockApp.post = ->
mockApp['delete'] = ->
mockApp.options = ->
mockApp.once = (name, callback)->
  callback(null, true)
mockApp.emit = ->
  em = new EventEmitter
  em.emit.apply @, arguments
mockApp.datasources = 
  db:
    name: 'db'
    connector: 'memory'
  mongo:
    name: 'mongo'
    connector: 'apihero-mongodb'
    settings:
      connector: 'apihero-mongodb'
require('../src').init mockApp