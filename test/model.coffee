fs              = require 'fs'
(chai           = require 'chai').should()
RikkiTikkiAPI   = require '../src'
describe 'RikkiTikkiAPI.Model Test Suite', ->

  @model = new RikkiTikkiAPI.model 'FooBerry', {name:"[Native::String]", value:"[Native::Number]"}

  it 'should have a modelName',=>
    @model.modelName.should.eq 'FooBerry'
  it 'should have a schema object',=>
     @model.schema.should.be.a 'object'
     @model.schema.name.should.eq '[Native::String]'
     @model.schema.value.should.eq '[Native::Number]'
  it 'should provide a client schema',=>
    @model.toClientSchema.should.be.a 'function'
    (schema = @model.toClientSchema()).should.be.a 'object'
    schema.paths.should.be.a 'object'
    schema.paths.name.should.be.a 'object'
    schema.paths.name.path.should.eq 'name'
    schema.paths.value.should.be.a 'object'
    schema.paths.value.path.should.eq 'value'
    schema.toSource.should.be.a 'function'
    schema.toSource().should.match /^\(function\(\)\s\{+/
  it 'should provide an API schema',=>
    @model.toAPISchema.should.be.a 'function'
    (schema = @model.toAPISchema()).should.be.a 'object'
    schema.toSource.should.be.a 'function'
    (js = schema.toSource()).should.be.a 'string'
    js.should.match /[\n\s\S]module.exports\s=\sAPI.model\('FooBerry'\,\sFooBerry\);$/
