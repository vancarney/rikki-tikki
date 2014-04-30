fs              = require 'fs'
path            = require 'path'
(chai           = require 'chai').should()
RikkiTikkiAPI   = require '../src/api'
describe 'RikkiTikkiAPI.Connection Test Suite', ->
  it 'should Connect with a basic DSN String', (done)=>
    @conn1 = new RikkiTikkiAPI.Connection "0.0.0.0"
    @conn1.on 'error', (e)-> console.log e
    @conn1.once 'open', => done() 
  it 'should close the connection', (done)=>
    @conn1.close (e) => done() if !e
  it 'should Connect with a DSN Object', (done)=>
    @conn2 = new RikkiTikkiAPI.Connection host:'0.0.0.0', port:27017
    @conn2.once 'open', => @conn2.close (e) => done() if !e
describe 'RikkiTikkiAPI.CollectionManager Test Suite', ->
  it 'should add Collections', (done)=>
    @connection = new RikkiTikkiAPI.Connection "0.0.0.0/test"
    @connection.once 'open', =>
      RikkiTikkiAPI.collectionMon = new RikkiTikkiAPI.CollectionMonitor RikkiTikkiAPI.connection = @connection
      @collections = new RikkiTikkiAPI.CollectionManager RikkiTikkiAPI.connection
      @collections.createCollection 'test1', (e,res) =>
        console.log e if e?
        done() if res?
  it 'should rename Collections', (done)=>
    @collections.renameCollection 'test1', 'testCollection', (e,res)=>
      console.log e if e?
      done() if res?
  it 'should drop Collections', (done)=>
    @collections.dropCollection 'testCollection', (e,res)=>
      console.log e if e?
      @connection.close()
      done() if res?


