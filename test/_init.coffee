module.exports = require 'chai'
{_}       = require 'lodash'
lt        = require 'loopback-testing'
server    = require './server/server/server'

describe 'init app', ->
  it 'should emit a `initialized` event', (done)=>
    server.on 'ahero-initialized', =>
      global.app          = server
      global.api_options  = require '../lib/classes/config/APIOptions'
      done.apply @, arguments
  it 'should have a reference set on Loopback', =>
    app.ApiHero.should.not.eq null