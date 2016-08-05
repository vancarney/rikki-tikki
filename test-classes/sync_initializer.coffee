(chai             = require 'chai').should()
SyncInitializer   = require '../src/classes/services/SyncInitializer'
describe 'SyncInitializer Class Test Suite', ->
  before (done)=>
    setTimeout (=>
      @syncService = app.ApiHero.SyncService.getInstance()
      done()
    ), 240
    
  it 'should init SyncItems', =>
    SyncInitializer.init app.ApiHero
    @syncService.listSyncKinds().length.should.eq 2
    
  after =>
    @syncService.removeSyncInstance 'schema'
    @syncService.removeSyncInstance 'collection'
   