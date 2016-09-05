{expect, should}  = require 'chai'
should()

fs                = require 'fs'
path              = require 'path'
Singleton         = require '../src/classes/base_class/Singleton'
EventEmitter      = require 'events'
SyncService       = require '../src/classes/services/SyncService'  
DataSource        = require '../src/classes/datasource/DataSource'
CollectionManager = require '../src/classes/collections/CollectionManager'
class EvtInstance extends EventEmitter
     
describe.only 'SyncService Class Test Suite', ->
  name    = 'SyncTestCollection'
  newName = 'RenamedTestCollection'
  syncService = SyncService.getInstance()
  @eCatch = null
  # before =>
    # fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'trees_path'}#{path.sep}#{name}.json"
    # fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'trees_path'}#{path.sep}#{name}.json"
    # fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'schema_path'}#{path.sep}#{name}.js"
    
  it 'should register a SyncInstance', =>
    syncService.registerSyncInstance 'test', @_em = new EvtInstance()
    expect(syncService.listSyncKinds().length).to.eq 1
    
  it 'should add an event handler', (done)=>
    @_listener = => done()
    syncService.addSyncHandler 'test', 'evt', @_listener
    @_em.emit 'changed', [
      operation: 'evt'
      kind: 'test'
      data: 'blah blah'
    ]
      
  it 'should list syncItems', =>
    syncService.listSyncKinds()?.length.should.eq 1
    
  it 'should remove an event handler', =>
    syncService.removeSyncHandler 'test', 'evt', @_listener
    @_em.emit 'changed', [
      operation: 'evt'
      kind: 'test'
      data: 'blah blah'
    ]
    # we test that it doesn't throw a "done() called multiple times" Error 
    
    
    
  it 'should unregister a SyncInstance', =>
    syncService.removeSyncInstance 'test'
    syncService.listSyncKinds()?.length.should.eq 0

  # after =>
    # fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'trees_path'}#{path.sep}#{name}.json"
    # fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'trees_path'}#{path.sep}#{name}.json"
    # fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'schema_path'}#{path.sep}#{name}.js"
    # fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'trees_path'}#{path.sep}#{newName}.json"
    # fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'trees_path'}#{path.sep}#{newName}.json"
    # fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'schema_path'}#{path.sep}#{newName}.js"          