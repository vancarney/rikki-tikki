fs                = require 'fs'
path              = require 'path'
(chai             = require 'chai').should()
module.exports.RikkiTikkiAPI = API = require 'rikki-tikki'
express           = require 'express'
Adapter           = require '../src/ExpressAdapter'
describe 'ExpressAdapter Test Suite', ->
  clazz = class Tester extends Adapter
  describe 'ExpressAdapter Overrides', =>
    it 'should require app to be passed in constructor params object', =>
      chai.expect(-> 
        new clazz().requestHandler()
      ).to.throw 'required param \'app\' was not defined in the adapter params object'
  describe 'ExpressAdapter Overrides', =>
    it 'should require method requestHandler to be overriden', =>
      chai.expect(-> 
        new clazz(app:{}).requestHandler()
      ).to.not.throw()
    it 'should require method responseHandler to be overriden', =>
      chai.expect(-> 
        new clazz(app:{}).responseHandler {setHeader:(->false), send:(->false)}, {status:200}
      ).to.not.throw()
    it 'should require method addRoute to be overriden', =>
      chai.expect(-> 
        new clazz(app:{}).addRoute()
      ).to.not.throw()
  describe 'ExpressAdapter Usage', =>
    it 'should create an Adapter Instance', =>
      (@adapter = Adapter.use app = express()).params.app.should.equal app
    it 'should register with an API Instance', =>
      (api = new API
        adapter:@adapter   
      ).__adapter.should.equal @adapter
    

