fs              = require 'fs'
path            = require 'path'
(chai           = require 'chai').should()
RikkiTikkiAPI   = require( '../src/api' )
describe 'RikkiTikkiAPI.ConfigLoader Test Suite', ->
  @configLoader = null 
  it 'should accept a config path as a String', =>
    @configLoader = new RikkiTikkiAPI.ConfigLoader './test/configs/conf_1.json'
    @configLoader.__config.should.be.a 'Object'
  it 'should retrieve an environment config by name', =>
    @configLoader.getEnv('development').host.should.equal '0.0.0.0'
  it 'should allow global params', =>
    RikkiTikkiAPI.CONFIG_PATH = './test/configs'
    RikkiTikkiAPI.CONFIG_FILENAME = 'conf_2.json'
    RikkiTikkiAPI.getFullPath().should.equal path.normalize "#{process.cwd()}/test/configs/conf_2.json"