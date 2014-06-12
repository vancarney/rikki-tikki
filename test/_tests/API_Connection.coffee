fs              = require 'fs'
path            = require 'path'
(chai           = require 'chai').should()
RikkiTikkiAPI   = require '../src/api'
describe 'RikkiTikkiAPI.Connection Test Suite', ->
  it 'should Connect with a basic DSN String', (done)=>
    @conn1 = new RikkiTikkiAPI.Connection "0.0.0.0"
    @conn1.on 'error', (e)-> #console.log arguments
    @conn1.once 'open', => done() 
  it 'should close the connection', (done)=>
    @conn1.close (e) => done() if !e
  it 'should Connect with a DSN Object', (done)=>
    @conn2 = new RikkiTikkiAPI.Connection host:'0.0.0.0', port:27017
    @conn2.once 'open', => @conn2.close (e) => done() if !e


