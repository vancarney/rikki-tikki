fs              = require 'fs'
(chai           = require 'chai').should()
RikkiTikkiAPI   = require '../src'
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
RikkiTikkiAPI.SCHEMA_PATH = "#{__dirname}/schemas"
APISchema    = require '../src/classes/schema/APISchema'

describe 'APISchema Test Suites', ->
  @schema = new APISchema 'APISchemaTest', {name:String, description:String}
  it 'should create source', =>
    (@source = @schema.toSource()).should.match /API\.model\('APISchemaTest',\sAPISchemaTest\);+$/