(chai           = require 'chai').should()
http            = require 'http'
Router          = require 'routes'
RikkiTikkiAPI   = require '../src/api'
describe 'RikkiTikkiAPI.CollectionManager Class Test Suite', ->
  it 'should setup our testing environment', (done)=>
    new RikkiTikkiAPI( {
      config_path: './test/configs'
      adapter: RikkiTikkiAPI.createAdapter 'routes', router:new Router
    }).on 'open', =>
      @collections = RikkiTikkiAPI.getCollectionManager()
      done()
  it 'should add Collections', (done)=>
    @collections.createCollection 'test1', (e,res) =>
      console.log e if e?
      done()
  it 'should rename Collections', (done)=>
    @collections.renameCollection 'test1', 'testCollection', (e,res)=>
      console.log e if e?
      done()
  it 'should drop Collections', (done)=>
    @collections.dropCollection 'testCollection', (e,res)=>
      console.log e if e?
      done()