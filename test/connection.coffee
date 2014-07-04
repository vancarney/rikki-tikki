fs              = require 'fs'
path            = require 'path'
(chai           = require 'chai').should()
RikkiTikkiAPI   = require '../src'
DSN             = RikkiTikkiAPI.DSN
describe 'Connection Test Suite', ->
  it 'should Connect with a basic DSN String', (done)=>
    @conn1 = new RikkiTikkiAPI.Connection "0.0.0.0"
    @conn1.on 'error', (e)-> #console.log arguments
    @conn1.once 'open', => done() 
  it 'should close the connection', (done)=>
    @conn1.close (e) => done() if !e
  it 'should Connect with a DSN Object', (done)=>
    DSN.loadConfig "#{__dirname}/configs/db.json", (e,dsn)=>
      @conn2 = new RikkiTikkiAPI.Connection dsn.toJSON()
      @conn2.once 'open', => @conn2.close (e) => done() if !e