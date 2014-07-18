{_}             = require 'underscore'
fs              = require 'fs'
path            = require 'path'
(chai           = require 'chai').should()
RikkiTikkiAPI   = require '../src'
SchemaTree = require '../src/classes/schema_tree/SchemaTree'
RikkiTikkiAPI.CONFIG_PATH = "#{__dirname}/configs"
RikkiTikkiAPI.SCHEMA_PATH = "#{__dirname}/schemas"
RikkiTikkiAPI.TREE_PATH   = "#{process.cwd()}/.rikki-tikki/trees"
describe 'SchemaTree Test Suite', ->
  @treePath = "#{RikkiTikkiAPI.TREE_PATH}/Test.json"
  it 'should create a SchemaTree', (done)=>
    (new SchemaTree).create @treePath, {name:String, value:Object}, (e,s)=>
      if e?
        throw e
      else
        done()
  it 'should load a SchemaTree', (done)=>
    (@tree = new SchemaTree @treePath
    ).on( 'error', (e)-> throw e
    ).on 'success', => done()
  it 'should update and save a SchemaTree', (done)=>
    @tree.set name:String, (e)=> 
      if e?
        throw e
      else
        fs.readFile @tree.__path, 'utf-8', (e,data)=>
          throw e if e?
          if JSON.parse(data, RikkiTikkiAPI.Schema.reviver).name == String
            done()
          else
            throw "data was not set"
  it 'should delete a SchemaTree', (done)=>
    @tree.destroy (e)=>
      if e?
        throw e
      else
        done()