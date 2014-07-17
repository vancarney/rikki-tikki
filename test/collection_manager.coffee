(chai           = require 'chai').should()
http            = require 'http'
Router          = require 'routes'
fs              = require 'fs'
DSN             = require 'mongo-dsn'
RikkiTikkiAPI   = require '../src'
RikkiTikkiAPI.CONFIG_PATH = "#{__dirname}/configs"
RikkiTikkiAPI.SCHEMA_PATH = "#{__dirname}/schemas"
Connection      = RikkiTikkiAPI.Connection
describe 'CollectionManager Test Suite', ->
  it 'should setup our test connection', (done)=>
    DSN.loadConfig "#{RikkiTikkiAPI.CONFIG_PATH}/db.json", (e,dsn)=>
      (@conn = new Connection dsn.toJSON()
      ).on 'open', =>
        RikkiTikkiAPI.getConnection = => @conn
        done()
  it 'should List existing Collections', (done)=>
    RikkiTikkiAPI.getCollectionMonitor().refresh =>
      @cm = RikkiTikkiAPI.getCollectionManager()
      @cm.listCollections().length.should.equal 0
      done()