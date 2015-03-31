(chai           = require 'chai').should()
http            = require 'http'
Router          = require 'routes'
fs              = require 'fs'
DSN             = require 'mongo-dsn'
RikkiTikkiAPI   = require '../src'

class Mod
  onRegister:->
  onRemove:->
describe 'ModuleManager Test Suite', ->
  it 'should register a module', (done)=>
    Mod::onRegister = -> 
      done() if @api?
    RikkiTikkiAPI.registerModule 'mod', Mod
  it 'should retrieve a module', =>
    (RikkiTikkiAPI.retrieveModule 'mod').should.be.a 'object'
  it 'should remove a module', =>
    (RikkiTikkiAPI.removeModule 'mod').should.be.a 'object'
  it 'should have removed the module', =>
    (typeof RikkiTikkiAPI.retrieveModule 'mod').should.equal 'undefined'