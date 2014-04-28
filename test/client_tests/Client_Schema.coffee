fs              = require 'fs'
(chai           = require 'chai').should()
_               = (require 'underscore')._
Backbone        = require 'backbone'
Backbone.$      = require( 'jQuery')
RikkiTikki      = require('../lib/client').RikkiTikki

# myNS.createSchema 'Products', name:String, description:String, price:Number

describe 'RikkiTikki.Schema Test Suite', ->
  myNS = _.extend {}, RikkiTikki || {}
  @schema = new myNS.Schema name:String, description:String, price:Number, foo:{type:Date, default:Date.now, illegal:true}
  console.log @schema
  it 'Schema should create paths', =>
    @schema.paths.name.path.should.equal 'name'
  it 'Schema should define an instance from a passed native Object', =>
    @schema.paths.name.instance.should.be.a 'function'
  it 'Schema should define an instance from a param type', =>
    @schema.paths.foo.instance.should.be.a 'function'
  it 'Schema should filter out invalid params', =>
    @schema.paths.foo.should.not.have.property 'illegal'
