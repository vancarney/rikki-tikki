fs              = require 'fs'
(chai           = require 'chai').should()
RikkiTikkiAPI   = require '../src'
ClientLoader    = require '../src/classes/client/ClientLoader'

describe 'ClientLoader Test Suites', ->
  it 'should load a client', (done) =>
    (@loader = new ClientLoader()).load (e,s) =>
      throw e if e?
      done()
  it 'should provide a client', =>
    @loader.toString().should.match /^\/\/\sGenerated\sby\sCoffeeScript+/
