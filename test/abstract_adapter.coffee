{_}             = require 'underscore'
(chai           = require 'chai').should()
expect          = chai.expect
RikkiTikkiAPI   = require '../src'
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
AbstractAdapter  = require '../src/classes/base_class/AbstractAdapter'
describe 'AbstractAdapter Test Suite', ->
  @clazz = class Test extends AbstractAdapter
    constructor:->
      Test.__super__.constructor.call @
  @implementation = class Impl extends AbstractAdapter
    constructor:->
      Impl.__super__.constructor.call @
    requestHandler:(req,res)->
      true
    responseHandler:(req,res)->
      true
    addRoute:(route, method, handler)->
      true
  it 'should require to be subclassed', =>
    msg = 'AbstractAdapter can not be directly instatiated\nhint: use a subclass instead.'
    expect((->new AbstractAdapter)).to.throw msg
    expect((->new (@clazz))).to.not.throw
  it 'should require requestHandler to be implemented by subclass', =>
    msg = 'Object.requestHandler(req,res) is not implemented'
    expect((new @clazz).requestHandler).to.throw msg
    ((new @implementation).requestHandler()).should.equal true
  it 'should require responseHandler to be implemented by subclass', =>
    msg = 'Object.responseHandler(req,res) is not implemented'
    expect((new @clazz).responseHandler).to.throw msg
    ((new @implementation).responseHandler()).should.equal true
  it 'should require addRoute to be implemented by subclass', =>
    msg = 'Object.addRoute(route, method, handler) is not implemented'
    expect((new @clazz).addRoute).to.throw msg
    ((new @implementation).addRoute()).should.equal true