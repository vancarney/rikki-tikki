fs              = require 'fs'
child_process   = require 'child_process'
(chai           = require 'chai').should()
_               = (require 'underscore')._
Backbone        = require 'backbone'
Backbone.$      = require( 'jQuery')
RikkiTikki      = require('../lib/client').RikkiTikki
proc            = child_process.spawn 'node', ['./scripts/server']
RikkiTikki.env  = 'development'
fun = (value)->
  typeof value == 'number'
schema = {
  name:String, 
  description:String,
  price:{
    type:Number, 
    validators:[fun, 'must be a number']
  }
}

RikkiTikki.createSchema 'Products', _.clone schema
RikkiTikki.PORT = 3006
myNS = RikkiTikki.createNameSpace 'myNS'
# console.log new myNS.Schema schema

describe 'RikkiTikki.Model Test Suite', ->
  it 'RikkiTikki.Model.saveAll should be STATIC', =>
    RikkiTikki.Model.saveAll.should.be.a 'function'
  it 'Model should be extensable', =>
    (@clazz = class Product extends (RikkiTikki.Model)).should.be.a 'function'
  it 'should safely get it\'s constructor.name', =>
    (RikkiTikki.getConstructorName @testModel = new @clazz()).should.equal 'Product'
    # console.log @testModel.getSchema()
  it 'should have a pluralized Class Name', =>
    (@testModel).className.should.equal 'Products'
  it 'should save Data to the API', (done)=>
    o = 
      name:"Fantastic Rubber Shirt"
      description:"embrace cutting-edge deliverables"
      price:10.75
    h = 
      success:(m,r,o)=>
        done()
      error:(m,r,o)->
        console.log 'error'
    @testModel.save o, h
  it 'should have an ObjectID after saving', =>
    # console.log @testModel
    (@testModel.get '_id').should.not.equal null
  it 'should update Data to the API', (done)=>
    @timeout 15000
    o = 
      active:true
    h = 
      success:(m,r,o)=>
        done()
      error:(m,r,o)=>
        console.log arguments
    @testModel.save o, h
  it 'should delete it\'s self from the API', (done)=>
    h = 
      success:(m,r,o)=>
        proc.kill 'SIGINT'
        done()
    @testModel.destroy h