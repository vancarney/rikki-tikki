{_}             = require 'underscore'
fs              = require 'fs'
path            = require 'path'
(chai           = require 'chai').should()
RikkiTikkiAPI   = require '../src/api'
RikkiTikkiAPI.SCHEMA_PATH = './test/schemas'
describe 'RikkiTikkiAPI.Schema Test Suite', ->
  it 'should Load an existing schema', (done)=>
    sm = RikkiTikkiAPI.SchemaManager.getInstance()
    _.each _.keys(sm.__loader.__schema), (schema)=>
      # console.log sm.fetchSchema( schema ).toAPISchema().toSource()
      # Foo = (new RikkiTikkiAPI.model schema, sm.__loader.__schema[schema])
      # console.log (new Foo {name:'Foo'}).toClientSchema().toString()
    done()
