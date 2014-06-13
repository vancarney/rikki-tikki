(chai           = require 'chai').should()
http            = require 'http'
Router          = require 'routes'
RikkiTikkiAPI   = require '../src'
fs              = require 'fs'
name            = 'NewCollection'

# module.parent.exports = RikkiTikkiAPI
# SyncService   = require '../src/api/classes/services/SyncService'
describe 'RikkiTikkiAPI.SyncService Class Test Suite', ->
  @timeout 15000
  console.log 'RikkiTikkiAPI.getCollectionManager().__instance'
  it 'should setup our testing environment', (done)=>
    @api = new RikkiTikkiAPI( {
      config_path: './test/configs'
      adapter: RikkiTikkiAPI.createAdapter 'routes', router:new Router
    }).on 'open', =>
      @collections = RikkiTikkiAPI.getCollectionManager()
      done()
  it 'should create Schemas and SchemTrees', (done)=>
      @collections.createCollection name, (e,col)=>
        throw e if e?
        iVal = setInterval (=>
          fs.exists (p = "#{RikkiTikkiAPI.getSchemaManager().__path}/#{name}.js"), (e)=>
            clearInterval iVal if e
            RikkiTikkiAPI.Util.File.readFile p, (e,data)=>
              throw e if e?
              done()
        ), 2000
  it 'should tear down our testing env', (done)=>
    @collections.dropCollection name, (e,col)=>
      throw e if e?
      done()
  it 'should teardown', (done)=>
    @api.disconnect =>
      delete @api
      done()