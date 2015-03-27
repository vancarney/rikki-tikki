(chai           = require 'chai').should()
http            = require 'http'
Router          = require 'routes'
fs              = require 'fs'
DSN             = require 'mongo-dsn'
RikkiTikkiAPI   = require '../src'
# RikkiTikkiAPI.CONFIG_PATH = "#{__dirname}/configs"
# RikkiTikkiAPI.SCHEMA_PATH = "#{__dirname}/schemas"
# Connection      = RikkiTikkiAPI.Connection
class Mod
  onRegister:(api)->
  onRemove:(api)->
describe 'ModuleManager Test Suite', ->
  it 'should register a module', (done)=>
    Mod::onRegister = => done()
    RikkiTikkiAPI.registerModule 'mod', Mod
