{should,expect} = require 'chai'
global._        = require( 'lodash' )._
global.fs       = require 'fs'
global.path     = require 'path'
global.should   = should
global.expect   = expect
global.app_root = __dirname
should()


EventEmitter        = require 'events'
global.api_options  = require '../src/classes/config/APIOptions'

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
global.app = require('../src').init mockApp, monitor_requests: false
global.app.ApiHero = 
  proxyEvent: (name, delegator)-> true
setTimeout (=>
    SyncService = require '../src/classes/services/SyncService'
    global.app.ApiHero.SyncService = SyncService
    global.app.ApiHero.createSyncInstance =  (name,clazz)=>
      SyncService = require '../src/classes/services/SyncService'
      SyncService.getInstance().registerSyncInstance.apply @, [name, new SyncService.SyncInstance( name, clazz )]
    global.app.ApiHero.destroySyncInstance = (name)=>
      SyncService = require '../src/classes/services/SyncService'
      SyncService.getInstance().removeSyncInstance name
  ), 120
      
