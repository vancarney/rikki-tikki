(chai           = require 'chai').should()
http            = require 'http'
Router          = require 'routes'
RikkiTikkiAPI   = require '../src/api'
name            = 'NewCollection'
# module.parent.exports = RikkiTikkiAPI
# SchemaService   = require '../src/api/classes/services/SchemaService'
describe 'RikkiTikkiAPI.SchemaService Class Test Suite', ->
  it 'should setup our testing environment', (done)=>
    new RikkiTikkiAPI( {
      config_path: './test/configs'
      adapter: RikkiTikkiAPI.createAdapter 'routes', router:new Router
    }).on 'open', =>
      @collections = RikkiTikkiAPI.getCollectionManager()
      @collections.createCollection name, (e,col)=>
        throw e if e?
        done()
  it 'should tear down our testing env', (done)=>
    @collections.dropCollection name, (e,col)=>
      throw e if e?
      done()