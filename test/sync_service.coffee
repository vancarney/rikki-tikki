(chai           = require 'chai').should()
http            = require 'http'
Router          = require 'routes'
RikkiTikkiAPI   = require '../src'
fs              = require 'fs'
Connection      = RikkiTikkiAPI.Connection
SyncService     = require '../src/classes/services/SyncService'
describe 'SyncService Class Test Suite', ->
  @timeout 15000
  name = 'SyncTestCollection'
  it 'should setup test env', (done)=>
    (@conn = new Connection 'mongodb://0.0.0.0:27017/testing'
    ).on 'open', =>
      RikkiTikkiAPI.getConnection = => @conn
      @sync        = SyncService.getInstance()
      @collections = RikkiTikkiAPI.getCollectionManager()
      done()
  it 'should create Schemas and SchemaTrees', (done)=>
    @collections.createCollection name, (e,col)=>
      throw e if e?
      setTimeout (=>
        fs.exists (p = "#{RikkiTikkiAPI.getSchemaManager().__path}/#{name}.js"), (e)=>
          # clearInterval iVal if e
          RikkiTikkiAPI.Util.File.readFile p, (e,data)=>
            throw e if e?
            done()
      ), 50
  it 'should tear down our testing env', (done)=>
    @collections.dropCollection name, (e,col)=>
      throw e if e?
      done()