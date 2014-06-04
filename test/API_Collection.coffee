(chai           = require 'chai').should()
http            = require 'http'
Router          = require 'routes'
RikkiTikkiAPI   = require '../src/api'
describe 'RikkiTikkiAPI.Collection Class Test Suite', ->
  it 'should setup our test collection', (done)=>
    new RikkiTikkiAPI( {
      config_path: './test/configs'
      adapter: RikkiTikkiAPI.createAdapter 'routes', router:new Router
    }).on 'open', =>
      RikkiTikkiAPI.getCollectionManager().createCollection 'Test', (e,col)=>
        throw e if e?
        done()
  it 'should get a Collection', (done)=>
    (@col = new RikkiTikkiAPI.Collection 'Test').getCollection (e,col)=>
      throw e if e?
      done()
  it 'should save a record to the Collection', (done)=>
    @col.save {name:"record 1", value:"foo"}, null, (e, res)=>
      throw e if e?
      done()
  it 'should find the record in the Collection', (done)=>
    @col.find {name:"record 1"}, null, (e, res)=>
      throw e if e?
      done()
  it 'should remove the record from the Collection', (done)=>
    @col.remove {name:"record 1"}, null, (e, res)=>
      throw e if e?
      done()
  it 'should tear down our test collection', (done)=>
    RikkiTikkiAPI.getCollectionManager().dropCollection 'Test', (e,col)=>
      throw e if e?
      done()