fs              = require 'fs'
(chai           = require 'chai').should()
RikkiTikkiAPI   = require '../src'
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
RikkiTikkiAPI.SCHEMA_PATH = "#{__dirname}/schemas"
ClientSchema    = require '../src/classes/schema/ClientSchema'

describe 'ClientSchema Test Suites', ->
  @schema = new ClientSchema 'ClientSchemaTest', {name:String, description:String}
  it 'should create source', =>
    (@source = @schema.toSource()).should.match /RikkiTikki\.Schema\);+[\s\S]+\);$/