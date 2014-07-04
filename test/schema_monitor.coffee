(chai           = require 'chai').should()
fs              = require 'fs'
http            = require 'http'
Router          = require 'routes'
RikkiTikkiAPI   = require '../src'
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
SchemaMonitor   = require '../src/classes/schema/SchemaMonitor'
describe 'SchemaMonitor Class Test Suite', ->
  @timeout 15000
  RikkiTikkiAPI.SCHEMA_PATH = "#{__dirname}/schemas"
  RikkiTikkiAPI.getOptions = ->
    new RikkiTikkiAPI.APIOptions
  it 'should emit init event', (done)=>
    (@schemaMonitor = SchemaMonitor.getInstance()
    ).once 'init', =>
      done()
  it 'should detect new schema files', (done)=>
    newListener = (data)=>
      @schemaMonitor.removeListener 'changed', newListener
      if data.added?
        data.added[0].name.should.equal 'Test'
        done()
    @schemaMonitor.on 'changed', newListener
    fs.writeFileSync "#{RikkiTikkiAPI.SCHEMA_PATH}/Test.js", ''
  # it 'should detect updated schema files', (done)=>
    # @schemaMonitor.removeAllListeners 'changed'
    # updateListener = (data)=>
      # console.log "update: #{JSON.stringify data}"
      # data.replaced[0].name.should.equal 'Test'
      # done()
    # @schemaMonitor.once 'changed', updateListener
    # setTimeout (=>
      # fs.appendFileSync "#{RikkiTikkiAPI.SCHEMA_PATH}/Test.js", "#{Date.now()}"
    # ), 500
  it 'should detect unlinked schema files', (done)=>
    @schemaMonitor.removeAllListeners 'changed'
    unlinkListener = (data)=>
      data.removed[0].name.should.equal 'Test'
      done()
    @schemaMonitor.once 'changed', unlinkListener
    setTimeout (=>
      fs.unlinkSync "#{RikkiTikkiAPI.SCHEMA_PATH}/Test.js"
    ), 500