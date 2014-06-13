{_}             = require 'underscore'
fs              = require 'fs'
path            = require 'path'
(chai           = require 'chai').should()
RikkiTikkiAPI   = require '../src'
RikkiTikkiAPI.SCHEMA_PATH = './test/schemas'
describe 'RikkiTikkiAPI.SchemaManager Test Suite', ->
  it 'should Load an existing schema', (done)=>
    @sm = RikkiTikkiAPI.getSchemaManager()
    @sm.listSchemas (e, list)=>
      throw e if e?
      done()
      # console.log sm.fetchSchema( schema ).toAPISchema().toSource()
      # Foo = (new RikkiTikkiAPI.model schema, sm.__loader.__schema[schema])
      # console.log (new Foo {name:'Foo'}).toClientSchema().toString()
    
