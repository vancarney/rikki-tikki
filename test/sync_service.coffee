(chai           = require 'chai').should()
http            = require 'http'
Router          = require 'routes'
RikkiTikkiAPI   = require '../src'
fs              = require 'fs'
Connection      = RikkiTikkiAPI.Connection
SyncService     = require '../src/classes/services/SyncService'
RikkiTikkiAPI.SCHEMA_API_REQUIRE_PATH = '../../lib/'
describe 'SyncService Class Test Suite', ->
  @timeout 15000
  name = 'SyncTestCollection'
  it 'should setup test env', (done)=>
    (@conn = new Connection 'mongodb://0.0.0.0:27017/testing'
    ).on 'open', =>
      RikkiTikkiAPI.getConnection = => @conn
      @sync         = SyncService.getInstance()
      @colMon       = RikkiTikkiAPI.getCollectionMonitor()
      @colManager   = RikkiTikkiAPI.getCollectionManager()
      done()
  it 'should create Schemas and Schema Trees', (done)=>
    fs.unlinkSync f if fs.existsSync f = "./.rikki-tikki/trees/#{name}.json"
    @colManager.createCollection name, (e,col)=>
      throw e if e?
      setTimeout (=>
        fs.exists (p = "#{RikkiTikkiAPI.getSchemaManager().__path}/#{name}.js"), (exists)=>
          @colManager.dropCollection name, (e,col)=>
            throw e if e?
            done()
      ), 1500
  it 'should tear down our testing env', (done)=>
    setTimeout (=>
      f = "#{RikkiTikkiAPI.getSchemaManager().__path}/_#{name}.js"
      unless fs.existsSync f
        fs.unlinkSync ".rikki-tikki/trees/#{name}.json"
        fs.unlinkSync "#{RikkiTikkiAPI.getSchemaManager().__path}/#{name}.js"
        throw "Collection '#{name}' was not destroyed (non-destructively) by SyncManager"
      fs.unlinkSync f
      done()
    ), 3000
    
    @colManager.dropCollection 'TestSchema', (e,col)=>
      fs.unlink f if fs.existsSync f = '../.rikki-tikki/trees/TestSchema.json'
          