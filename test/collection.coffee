(chai           = require 'chai').should()
http            = require 'http'
Router          = require 'routes'
fs              = require 'fs'
DSN             = require 'mongo-dsn'
mongodb         = require 'mongodb'
ObjectID        = require('mongodb').ObjectID
RikkiTikkiAPI   = require '../src'
RikkiTikkiAPI.CONFIG_PATH = "#{__dirname}/configs"
RikkiTikkiAPI.SCHEMA_PATH = "#{__dirname}/schemas"
Connection      = RikkiTikkiAPI.Connection
describe 'Collection Class Test Suite', ->
  it 'should setup our test connection', (done)=>
    DSN.loadConfig "#{RikkiTikkiAPI.CONFIG_PATH}/db.json", (e,dsn)=>
      (@conn = new Connection dsn.toJSON()
      ).on 'open', =>
        RikkiTikkiAPI.getConnection = => @conn
        done()
  it 'should create a Collection', (done)=>
    RikkiTikkiAPI.Collection.create 'Test', {}, (e,col)=>
      throw e if e?
      done()
  it 'should get a Collection', (done)=>
    (@_collection = new RikkiTikkiAPI.Collection 'Test').getCollection (e,@col)=>
      throw e if e?
      done()
  it 'should save a record to the Collection', (done)=>
    @col.save {name:"record 1", value:"foo"}, null, (e, res)=>
      throw e if e?
      done()
  it 'should find the record in the Collection', (done)=>
    @col.find {name:"record 1"}, {}, (e, res)=>
      throw e if e?
      res.toArray (e,doc)=>
        done() if doc.length and (@record_id = doc[0]._id)?
  it 'should find the record in the Collection by ObjectId', (done)=>
    # console.log new ObjectID @record_id
    q = _id: new ObjectID "#{@record_id}"
    @_collection.find q, {}, (e, docs)=>
      throw e if e?
      console.log docs
      done() if "#{@record_id}" == "#{docs[0]._id}"
  it 'should find the record in the Collection by ObjectId with findOne', (done)=>
    q = _id: new ObjectID "#{@record_id}"
    @_collection.findOne q, {}, (e, doc)=>
      throw e if e?
      done() if "#{@record_id}" == "#{doc._id}"
  it 'should derive a Tree from the Collection', (done)=>
    @_collection.save [
      {name:"record 2", value:false},
      {name:"record 3", value:false},
      {name:"record 4", value:false},
      {name:"record 5", value:false}
      ], {}, (e, res)=>
      throw e if e?
      @_collection.getTree (e, tree)=>
        throw e if e?
        tree._id.should.equal 'ObjectID'
        tree.name.should.equal 'String'
        tree.value.should.equal 'Mixed'
        done()
  it 'should rederive a Tree from the Collection', (done)=>
    @_collection.save [
      {name:"record 6", value:false},
      {name:"record 7", value:false},
      {name:"record 8", value:false},
      {name:"record 9", value:false},
      {name:"record 10", value:false}
      ], null, (e, res)=>
      throw e if e?
      @_collection.getTree (e, tree)=>
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
      done()