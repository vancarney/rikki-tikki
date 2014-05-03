fs              = require 'fs'
child_process   = require 'child_process'
(chai           = require 'chai').should()
_               = (require 'underscore')._
Backbone        = require 'backbone'
Backbone.$      = require( 'jQuery')
RikkiTikki      = require('../lib/client').RikkiTikki


describe 'RikkiTikki.Function Test Suite', ->
  it 'should create a function from a string', =>
    RikkiTikki.Function.fromString("function(){ return 'success'; }")().should.equal 'success'
    RikkiTikki.Function.fromString('Native::Date').should.equal Date
  it 'should stringify native and user functions', =>
    RikkiTikki.Function.toString((-> return true)).should.be.a 'string'
    RikkiTikki.Function.toString(Date).should.equal 'Native::Date'
    
    
