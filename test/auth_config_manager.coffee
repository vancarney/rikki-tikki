fs                = require 'fs'
path              = require 'path'
(chai             = require 'chai').should()
RikkiTikkiAPI     = require '../src'
RikkiTikkiAPI.AUTH_CONFIG_PATH = ".#{path.sep}test#{path.sep}scripts#{path.sep}configs#{path.sep}auth"
RikkiTikkiAPI.getOptions = =>
  new RikkiTikkiAPI.APIOptions().toJSON()
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
AuthConfigManager = require '../src/classes/auth/AuthConfigManager'

describe 'AuthConfigManager Test Suites', ->
  it 'should load auth configs', (done)=>
    AuthConfigManager.getInstance().load (e,s)=>
      throw e if e?
      done()
