(chai           = require 'chai').should()
fs              = require 'fs'
http            = require 'http'
Router          = require 'routes'
RikkiTikkiAPI   = require '../src'
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
SchemaMonitor   = require '../src/classes/schema/SchemaMonitor'
describe 'SchemaMonitor Class Test Suite', ->
  RikkiTikkiAPI.SCHEMA_PATH = "#{__dirname}/schemas"
  RikkiTikkiAPI.getOptions = ->
    new RikkiTikkiAPI.APIOptions
  @schemaMonitor = SchemaMonitor.getInstance()
  # it 'should emit init event', (done)=>
    # (@schemaMonitor = SchemaMonitor.getInstance()
    # ).once 'init', =>
      # done()
  it 'should detect new schema files', (done)=>
    newListener = (data)=>
      @schemaMonitor.removeListener 'changed', newListener
      if data.added?
        data.added[0].name.should.equal 'Test'
        done()
    @schemaMonitor.on 'changed', newListener
    fs.writeFile "#{RikkiTikkiAPI.SCHEMA_PATH}/Test.js", '', =>
      setTimeout (=>
        @schemaMonitor.refresh()
      ), 5
  it 'should detect updated schema files', (done)=>
    @schemaMonitor.removeAllListeners 'changed'
    updateListener = (data)=>
      data.replaced[0].name.should.equal 'Test'
      done()
    @schemaMonitor.on 'changed', updateListener
    setTimeout (=>
      fs.appendFile "#{RikkiTikkiAPI.SCHEMA_PATH}/Test.js", "#{Date.now()}", =>
        setTimeout (=>
          @schemaMonitor.refresh()
        ), 5
    ), 1100
  it 'should detect unlinked schema files', (done)=>
    @schemaMonitor.removeAllListeners 'changed'
    unlinkListener = (data)=>
      @schemaMonitor.removeAllListeners 'changed'
      data.removed[0].name.should.equal 'Test'
      done()
    @schemaMonitor.on 'changed', unlinkListener
    fs.unlink "#{RikkiTikkiAPI.SCHEMA_PATH}/Test.js", =>
      setTimeout (=>
        @schemaMonitor.refresh()
      ), 5