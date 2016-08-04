{should,expect}   = require 'chai'
global.expect     = expect
should()

fs                = require 'fs'
path              = require 'path'
Singleton         = require '../src/classes/base_class/Singleton'
SyncInstance      = require '../src/classes/services/SyncInstance'

describe 'SyncInstance Test Suite', ->
  it 'should error if kind is not present', =>
    expect(-> new SyncInstance).to.throw 'kind is required'
  it 'should error if kind is not of type string', =>
    expect(-> new SyncInstance {}).to.throw 'kind was required to be string type was object'
  it 'should error if class is not present', =>
    expect(-> new SyncInstance 'kind').to.throw 'clazz is required'
  it 'should error if class is not a subclass of Singleton', =>
    expect(-> new SyncInstance 'kind', {}).to.throw 'clazz must be instance of Singleton'
  it 'should create an instance', =>
    expect(-> new SyncInstance 'kind', Singleton).to.not.throw
  it 'should fire an init event', (done)->
    inst = new SyncInstance 'kind', Singleton
    inst.on 'init', (data)=>
      data.should.be.a 'object'
      done() 
    inst.onInit foo:'bar'
  it 'should fire a changed event', (done)->
    inst = new SyncInstance 'kind', Singleton
    inst.on 'changed', (data)=>
      data[0].kind.should.eq 'kind'
      data[0].data.should.eq 'bar'
      done()
    inst.onChanged foo:['bar']
