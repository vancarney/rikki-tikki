{_}             = require 'underscore'
fs              = require 'fs'
path            = require 'path'
(chai           = require 'chai').should()
expect          = chai.expect
RikkiTikkiAPI   = require '../src'
RikkiTikkiAPI.SCHEMA_PATH = "#{__dirname}/schemas"
RikkiTikkiAPI.getOptions = ->
  new RikkiTikkiAPI.APIOptions
RikkiTikkiAPI.getSchemaTree = -> {}
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
Util = RikkiTikkiAPI.Util
describe 'SchemaManager Test Suite', ->
  @sm = RikkiTikkiAPI.getSchemaManager()
  it 'should List existing schema', (done)=>
    # (@sm = RikkiTikkiAPI.getSchemaManager()
    # ).on( 'error', (e)->
      # console.log 'err'
      # throw e
    # ).on 'success', (schemas)=>
      # console.log 'success'
    @sm.listSchemas (e, list)=>
      throw e if e?
      list.length.should.equal 1
      done()
  it 'should Create a new schema', (done)=>
    @sm.createSchema 'CreatedSchema', (e,s)=>
      throw e if e?
      done()      
  it 'should Save a schema', (done)=>
    @sm.saveSchema 'CreatedSchema', (e,s)=>
      throw e if e?
      done()
  it 'should not Save a schema that does not exist', (done)=>
    @sm.saveSchema 'foo', (e,s)=>
      e.should.equal 'Schema \'foo\' was not found'
      done()
  it 'should provide a schema map', =>
    expect(@sm.toJSON().__schemas__['CreatedSchema']).to.exist
  it 'should Rename a schema', (done)=>
    @sm.renameSchema 'CreatedSchema', 'RenamedSchema', (e,s)=>
      throw e if e?
      done()
  it 'should non-destructively Destroy a schema', (done)=>
    @sm.destroySchema 'RenamedSchema', (e,s)=>
      throw e if e?
      unless fs.existsSync "#{RikkiTikkiAPI.SCHEMA_PATH}/_RenamedSchema.js"
        throw 'error: SchemaManager was destructive in non-detructve mode'
      fs.unlinkSync "#{RikkiTikkiAPI.SCHEMA_PATH}/_RenamedSchema.js"
      done()
  it 'should destructively Destroy a schema', (done)=>
    @sm = RikkiTikkiAPI.getSchemaManager()
    setTimeout (=>
      RikkiTikkiAPI.DESTRUCTIVE = true
      @sm.createSchema 'DeleteMe', (e,s)=>
        @sm.destroySchema 'DeleteMe', (e,s)=>
          RikkiTikkiAPI.DESTRUCTIVE = false
          throw e if e?
          if fs.existsSync "#{RikkiTikkiAPI.SCHEMA_PATH}/_DeleteMe.js"
            throw 'error: SchemaManager was non-destructive in detructve mode'
            fs.unlinkSync "#{RikkiTikkiAPI.SCHEMA_PATH}/_DeleteMe.js"
          done()
    ), 200
    
    
    
      # console.log sm.fetchSchema( schema ).toAPISchema().toSource()
      # Foo = (new RikkiTikkiAPI.model schema, sm.__loader.__schema[schema])
      # console.log (new Foo {name:'Foo'}).toClientSchema().toString()