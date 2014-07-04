{_}             = require 'underscore'
fs              = require 'fs'
path            = require 'path'
(chai           = require 'chai').should()
Router          = require 'routes'
RikkiTikkiAPI   = require '../src'
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
SchemaLoader    = require '../src/classes/schema/SchemaLoader'
# RikkiTikkiAPI.SCHEMA_PATH = './test/schemas'
describe 'RikkiTikkiAPI.SchemaLoader Test Suite', ->
