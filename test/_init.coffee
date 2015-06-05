{_}       = require 'lodash'
(chai     = require 'chai').should()
expect    = chai.expect
lt        = require 'loopback-testing'
server    = require './server/server/server'

describe 'init app', ->
  it 'should emit a `ready` event', (done)=>
    server.on 'ahero-initialized', =>
      global.app = server
      global.api_options = require '../lib/classes/config/APIOptions'
      done()
  it 'should have a reference set on Loopback', =>
    app.ApiHero.should.not.eq null