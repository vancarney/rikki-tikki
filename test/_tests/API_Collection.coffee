(chai           = require 'chai').should()
http            = require 'http'
Router          = require 'routes'
fs              = require 'fs'
RikkiTikkiAPI   = require '../src/api'
describe 'RikkiTikkiAPI.Collection Class Test Suite', ->
  it 'should setup our test collection', (done)=>
    new RikkiTikkiAPI( {
      destructive: true
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
  it 'should derive a Tree from the Collection', (done)=>
    @col.save [
      {name:"record 2", value:false},
      {name:"record 3", value:false},
      {name:"record 4", value:false},
      {name:"record 5", value:false}
      ], null, (e, res)=>
      throw e if e?
      @col.getTree (e, tree)=>
        throw e if e?
        tree._id.should.equal 'ObjectID'
        tree.name.should.equal 'String'
        tree.value.should.equal 'Mixed'
        done()
  it 'should rederive a Tree from the Collection', (done)=>
    @col.save [
      {name:"record 6", value:false},
      {name:"record 7", value:false},
      {name:"record 8", value:false},
      {name:"record 9", value:false},
      {name:"record 10", value:false}
      ], null, (e, res)=>
      throw e if e?
      @col.getTree (e, tree)=>
        throw e if e?
        tree._id.should.equal 'ObjectID'
        tree.name.should.equal 'String'
        tree.value.should.equal 'Boolean'
        done()
  it 'should remove a record from the Collection', (done)=>
    @col.remove {name:"record 1"}, null, (e, res)=>
      throw e if e?
      done()
  it 'should tear down our test collection', (done)=>
    @col.drop (e,col)=>
      throw e if e?
      throw 'Collection was not destroyed' if !col
      fs.unlinkSync './test/schemas/Test.js'
      fs.unlinkSync './test/configs/schema_trees/Test.json'
      done()