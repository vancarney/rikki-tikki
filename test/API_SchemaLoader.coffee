{_}             = require 'underscore'
fs              = require 'fs'
path            = require 'path'
(chai           = require 'chai').should()
Router          = require 'routes'
RikkiTikkiAPI   = require '../src'
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
SchemaLoader    = require '../src/classes/schema/SchemaLoader'
RikkiTikkiAPI.SCHEMA_PATH = './test/schemas'
describe 'RikkiTikkiAPI.SchemaLoader Test Suite', ->
  it 'should setup our testing environment', (done)=>
    @api = new RikkiTikkiAPI( {
      config_path: './test/configs'
      adapter: RikkiTikkiAPI.createAdapter 'routes', router:new Router
    }).on 'open', =>
      @schemaLoader = new SchemaLoader
      done()
  it 'should create a schema file', (done)=>
    @schemaLoader.create 'TestSchema', {name:String, details:String, created_on:Date, owner_id:'ObjectID'}, (e)=>
      throw e if e?
      done()
  describe 'load schema files', =>
    it 'should load the created schema file', (done)=>
      (new SchemaLoader).load './test/schemas/TestSchema.js', (e, data)=>
        throw e if e?
        data.should.be.a 'object'
        # RikkiTikkiAPI.Util.Object.isOfType( data, RikkiTikkiAPI.Schema ).should.equal true
        done()
  it 'should hide a schema file on destroy', (done)=>
    @schemaLoader.destroy (e)=>
      throw e if e?
      done()
  it 'should teardown our test by deleting the hidden schema file', (done)=>
    fs.unlink "#{RikkiTikkiAPI.SCHEMA_PATH}/_TestSchema.js", (e)=>
      throw e if e?
      done()
  it 'should teardown', (done)=>
    @api.disconnect =>
      delete @api
      done()