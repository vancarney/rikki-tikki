{_}             = require 'underscore'
(chai           = require 'chai').should()
expect          = chai.expect
RikkiTikkiAPI   = require '../src'
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
AbstractLoader  = require '../src/classes/base_class/AbstractLoader'
describe 'AbstractLoader Test Suite', ->
  @clazz = class Test extends AbstractLoader
  it 'should require to be subclassed', =>
    msg = 'AbstractAdapter can not be directly instatiated\nhint: use a subclass instead.'
    expect((->new AbstractLoader)).to.throw msg
    expect((->new (@clazz))).to.not.throw msg
  it 'should detect if a pathExists', =>
    (new @clazz).pathExists( 'test/data/fake.json' ).should.equal false
    (new @clazz).pathExists( 'test/data/products.json' ).should.equal true
  it 'should load and emit error event if file does not exist', (done)=>
    (new @clazz 'test/data/fake.json').on 'error', => done()
  it 'should load and emit success event if file loads', (done)=>
    (new @clazz 'test/data/products.json').on 'success', => done()
  it 'should allow load to be called directly', (done)=>
    (products = new @clazz).load 'test/data/products.json', (e,s)=>
      return throw e if e
      # cache the initial data to use on reset
      @cache = _.union [], products.__data
      done()
  it 'should get a value from the loaded document', (done)=>
    (@products = new @clazz 'test/data/products.json').on 'success', =>
      @product = @products.get 0
      @product.should.be.a 'object'
      @product.name.should.equal 'Fantastic Rubber Shirt'
      done()
  it 'should set a value to the loaded document', =>
    @product.name  = 'A New You'
    @products.set 0, @product
    p = @products.get 0
    p.should.be.a 'object'
    p.name.should.equal 'A New You'
  it 'should save the data back to the document', (done)=>
    @products.save (e,r)=>
      return throw e if e?
      (p = new @clazz 'test/data/products.json').on 'success', (r)=>
        (prod = p.get 0).should.be.a 'object'
        prod.name.should.equal 'A New You'
        done()
  it 'should rename the document', (done)=>
    path = 'test/data/products.json'
    new_path = 'test/data/_products.json'
    (products = new @clazz path).on 'success', (e,r)=>
      products.rename new_path, (e,r)=>
        throw e if e?
        (products.pathExists path).should.equal false
        (products.pathExists new_path).should.equal true
        done()
  it 'should delete the document', (done)=>
    path = 'test/data/_products.json'
    (products = new @clazz path).on 'success', =>
      products.destroy (e)=>
        throw e if e?
        (products.pathExists path).should.equal false
        done()
  it 'should create a new document', (done)=>
    path = 'test/data/products.json'
    (products = new @clazz).create path, @cache, (e,r)=>
      throw e if e?
      (products.pathExists path).should.equal true
      done()