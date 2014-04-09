fs              = require 'fs'
(chai           = require 'chai').should()
_               = (require 'underscore')._
Backbone        = require 'backbone'
Backbone.$      = require( 'jQuery')
RikkiTikki      = require('../lib/client').RikkiTikki
# server          = true
# service          = require './scripts/server'

# if (typeof process.env.PARSE_APP_ID == 'undefined' or typeof process.env.PARSE_REST_KEY == 'undefined')
  # console.error 'Failure: PARSE_APP_ID and PARSE_REST_KEY are required to be set in your env vars to run tests'
  # process.exit 1
  
# RikkiTikki.APP_ID   = process.env.PARSE_APP_ID
# RikkiTikki.REST_KEY = process.env.PARSE_REST_KEY
  
describe 'RikkiTikki.Model Test Suite', ->
  it 'RikkiTikki.Model.saveAll should be STATIC', =>
    RikkiTikki.Model.saveAll.should.be.a 'function'
  it 'Model should be extensable', =>
    (@clazz = class Product extends (RikkiTikki.Model)).should.be.a 'function'
  it 'should safely get it\'s constructor.name', =>
    (RikkiTikki.getConstructorName @testModel = new @clazz()).should.equal 'Product'
  it 'should have a pluralized Class Name', =>
    (@testModel).className.should.equal 'Products'
  it 'should save Data to the API', (done)=>
    @timeout 15000
    # RikkiTikki.API_URI = 'http://0.0.0.0:3001/api/1/'
    o = 
      name:"Fantastic Rubber Shirt"
      description:"embrace cutting-edge deliverables"
      price:'10.75'
    h = 
      success:(m,r,o)=>
        console.log 'completed'
        done()
      error:(m,r,o)->
        console.log 'error'
    @testModel.save o, h
  it 'should have an ObjectID after saving', =>
    console.log @testModel
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
        done()
    @testModel.destroy h