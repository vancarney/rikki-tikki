{_}             = require 'underscore'
(chai           = require 'chai').should()
expect          = chai.expect
RikkiTikkiAPI   = require '../src'
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
module.exports.Singleton     = require '../src/classes/base_class/Singleton'
AbstractMonitor  = require '../src/classes/base_class/AbstractMonitor'
  

foo = (->
  class Foo extends AbstractMonitor
  Foo.getInstance()
)()

impl = (->
  class Impl extends AbstractMonitor
    fooSource: [{value:1}]
    __exclude: [/^filter+$/]
    constructor:->
      Impl.__super__.constructor.call @
    getValues:->
      _.pluck @__collection, 'value'
    refresh:(callback)->
      ex = []
      error = null
      try
        _.each @fooSource, (val,key)=>
          ex.push val if 0 <= @getValues().indexOf val.value
        _.each (rm = _.compact _.difference( @getValues(), _.pluck(@fooSource, 'value'))), (item)=>
          @__collection.removeItemAt @getValues().indexOf item
        @__collection.setSource list if (list = _.difference @fooSource, ex).length
      catch e
        error = e
      callback?.apply @, if error? then [error, null] else [null, list]
)() 
describe 'AbstractMonitor Test Suite', ->
  it 'should require method "refresh" to be implemented by subclass', =>
    msg = 'Object.refresh(callback) is not implemented'
    expect(foo.refresh).to.throw msg
    expect(impl.getInstance().refresh).to.not.throw msg
  it 'should emit an "init" event' , (done)=>
    @obj = impl.getInstance().once( 'init', =>
      done()
    )
  it 'should refresh', (done)=>
    impl.getInstance().refresh => 
      done()
  it 'should filter out regex matched', =>
    (_.filter ['foo','bar','filter'], impl.getInstance().filter).length.should.equal 2
    
    