{_}       = require 'lodash'
(chai     = require 'chai').should()
expect    = chai.expect
lt        = require 'loopback-testing'
server    = require '../examples/server/server'

describe 'init app', ->
  it 'should emit a `ready` event', (done)=>
    server.on 'ready', =>
      global.app = server
      done()