fs              = require 'fs'
(chai           = require 'chai').should()
_               = (require 'underscore')._
Backbone        = require 'backbone'
Backbone.$      = require( 'jQuery')
RikkiTikki      = require('../lib/client').RikkiTikki
child_process   = require 'child_process'
proc            = child_process.spawn 'node', ['./scripts/server']

# server          = true
# service          = require './scripts/server'

# if (typeof process.env.PARSE_APP_ID == 'undefined' or typeof process.env.PARSE_REST_KEY == 'undefined')
  # console.error 'Failure: PARSE_APP_ID and PARSE_REST_KEY are required to be set in your env vars to run tests'
  # process.exit 1
  
# RikkiTikki.APP_ID   = process.env.PARSE_APP_ID
# RikkiTikki.REST_KEY = process.env.PARSE_REST_KEY

# init data to test with
clazz = class Product extends RikkiTikki.Model
# _.each require( './data/products.json' ).Products, (v,k)=>
  # model = new clazz
  # h = 
    # error:(m,r,o)->
      # console.log 'error'
  # model.save v, h
  
describe 'RikkiTikki.Collections Test Suite', ->
  @timeout 10000
  it 'Collection should be extensable', =>
    RikkiTikki.PORT = 3006
    (@clazz = class Products extends (RikkiTikki.Collection)).should.be.a 'function'
  # it 'should safely get it\'s constructor.name', =>
    # (RikkiTikki.getConstructorName @testCol = new @clazz()).should.equal 'Products'
  # it 'should have a pluralized Class Name', =>
    # (@testCol).className.should.equal 'Products'
  # it 'should perform a basic Query', (done)=>
    # @clazz.equalTo('name','Incredible Rubber Computer').fetch
      # success:(m,r,o)=>
        # done()
      # error:->
        # console.log arguments
  it 'should perform a complex Query', (done)=>
    # console.log RikkiTikki.Query.or @clazz.contains('name','Computer').greaterThanOrEqualTo('price',10)
    q  = @clazz.contains('name','Computer').greaterThanOrEqualTo 'price', 10
    q2 = @clazz.contains('name','Incredible').lessThanOrEqualTo('price',10).or(q)
    # console.log "q2.query: #{JSON.stringify q2.query()}"
    @clazz.contains('name','Incredible').lessThanOrEqualTo('price',10).or(q).fetch
      success:(m,r,o)=>
        done()
      error:->
        console.log arguments
# describe 'RikkiTikki.SchemaLoader Test Suite', ->
  # @timeout 10000
  it 'RikkiTikki should load Schemas', (done)=>
    RikkiTikki.initialize {port:3006}, (e,res)=>
      console.error e if e?
      if res
        RikkiTikki.getSchema('product').should.be.a 'Object'
        #console.log RikkiTikki.getSchema('product') #.virtuals #.short_desc.should.be.a 'Function'
        done()
