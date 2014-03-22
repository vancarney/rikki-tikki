fs              = require 'fs'
path            = require 'path'
(chai           = require 'chai').should()
RikkiTikkiAPI   = require( '../lib/api' ).RikkiTikkiAPI
describe 'RikkiTikkiAPI.CollectionManager Test Suite', ->
  it 'should add Collections', (done)=>
    @connection = new RikkiTikkiAPI.Connection "0.0.0.0/test"
    @connection.once 'open', (e)=>
      @collections = new RikkiTikkiAPI.CollectionManager @connection
      @collections.createCollection 'test1', null, (e,res) =>
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