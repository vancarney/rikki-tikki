fs              = require 'fs'
child_process   = require 'child_process'
(chai           = require 'chai').should()
_               = (require 'underscore')._
Backbone        = require 'backbone'
Backbone.$      = require( 'jQuery')
RikkiTikki      = require('../lib/client').RikkiTikki

# myNS.createSchema 'Products', name:String, description:String, price:Number

describe 'RikkiTikki.Schema Client Test Suite', ->
  myNS = RikkiTikki.createNameSpace 'myNS' #_.extend {}, RikkiTikki || {}
  @schema = new myNS.Schema name:String, description:String, price:Number, foo:{type:Date, default:Date.now, illegal:true, validators:[((value)-> typeof value == 'string'), 'must be string']}
  # console.log @schema #.paths.foo #.validators
  it 'Schema should create paths', =>
    @schema.paths.name.path.should.equal 'name'
  it 'Schema should define an instance from a passed native Object', =>
    @schema.paths.name.instance.should.be.a 'function'
  it 'Schema should define an instance from a param type', =>
    @schema.paths.foo.instance.should.be.a 'function'
  it 'Schema should allow validators', =>
    @schema.paths.foo.validators.should.be.a 'Array'
    @schema.paths.foo.validators[0][0].should.be.a 'function'
  it 'Schema should filter out invalid params', =>
    @schema.paths.foo.should.not.have.property 'illegal'