{_}             = require 'underscore'
fs              = require 'fs'
path            = require 'path'
(chai           = require 'chai').should()
expect          = chai.expect
RikkiTikkiAPI   = require '../src'
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
APIOptions      = require '../src/classes/config/APIOptions'
AppConfig       = require '../src/classes/config/AppConfig'
describe 'Hash Class Test Suite', ->
  it 'should get APIOptions',=>
    (@opts = new APIOptions).get('schema_path').should.equal RikkiTikkiAPI.SCHEMA_PATH
  it 'should get APIConfig',=>
    (@conf = new AppConfig).get('trees_path').should.equal "#{process.cwd()}#{path.sep}.rikki-tikki#{path.sep}trees"
  it 'should maintain discrete values in both hashes',=>
    console.log @opts.valueOf()
    @opts.get('schema_path').should.equal RikkiTikkiAPI.SCHEMA_PATH
    # @conf.get('trees_path').should.equal "#{process.cwd()}#{path.sep}.rikki-tikki#{path.sep}trees"
