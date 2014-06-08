(chai           = require 'chai').should()
http            = require 'http'
Router          = require 'routes'
RikkiTikkiAPI   = require '../src/api'
fs              = require 'fs'
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
SchemaMonitor   = require '../src/api/classes/schema/SchemaMonitor'
describe 'RikkiTikkiAPI.SchemaMonitor Class Test Suite', ->
  it 'should setup our testing environment', (done)=>
    new RikkiTikkiAPI( {
      config_path: './test/configs'
      schema_path: './test/schemas'
      adapter: RikkiTikkiAPI.createAdapter 'routes', router:new Router
    }).on 'open', =>
      @schemaMonitor = SchemaMonitor.getInstance() 
      done()
  it 'should detect new schema files', (done)=>
    @schemaMonitor.once 'changed', (data)=>
      data.added[0].name.should.equal 'Test'
      done()
    fs.writeFileSync './test/schemas/Test.js', ''
  it 'should detect updated schema files', (done)=>
    @schemaMonitor.once 'changed', (data)=>
      data.replaced[0].name.should.equal 'Test'
      done()
    fs.appendFileSync './test/schemas/Test.js', Date.now()
  it 'should detect unlinked schema files', (done)=>
    @schemaMonitor.once 'changed', (data)=>
      data.removed[0].name.should.equal 'Test'
      done()
    fs.unlink './test/schemas/Test.js'