{_}             = require 'underscore'
fs              = require 'fs'
path            = require 'path'
(chai           = require 'chai').should()
RikkiTikkiAPI   = require '../src/api'
RikkiTikkiAPI.CONFIG_PATH = './test/config'
RikkiTikkiAPI.SCHEMA_PATH = './test/schemas'
describe 'RikkiTikkiAPI.SchemaTree Test Suite', ->
  it 'should get a SchemaTreeManager Instance', ()=>
    (@sm = RikkiTikkiAPI.SchemaTreeManager.getInstance()).should.be.a 'Object'
  it 'should create a new SchemaTree item', (done)=>
    @sm.createTree 'TestOne', null, (e)=>
      if e?
        throw e
      else
        done()
  it 'should update and save a SchemaTree item', (done)=>
    @sm.getTree 'TestOne', (e, tree)=>
      if e?
        throw e
      else
        tree.set name:String, (e)=> 
          if e?
            throw w
          else
            fs.readFile tree.__path, 'utf-8', (e,data)=>
              throw e if e?
              if JSON.parse(data, RikkiTikkiAPI.Schema.reviver).name == String
                done()
              else
                throw "data was not set"
  it 'should delete a SchemaTree item', (done)=>
    @sm.destroyTree 'TestOne', (e)=>
      if e?
        throw e
      else
        done()
