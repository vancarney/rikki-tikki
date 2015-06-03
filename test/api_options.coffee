{_}             = require 'lodash'
path            = require 'path'
(chai           = require 'chai').should()
expect          = chai.expect
Hash            = require 'strictly-hash'
APIOptions      = require '../lib/classes/config/APIOptions'
describe 'APIOptions Test Suite', ->
  it 'should get APIOptions instance',=>
    (APIOptions instanceof Hash).should.equal true
  it 'should get schema_path',=>
    APIOptions.get('schema_path').should.equal "#{process.cwd()}#{path.sep}schemas"
  it 'should maintain discrete values in both hashes',=>
    APIOptions.set 'schema_path', "#{process.cwd()}#{path.sep}__foobar__"
    APIOptions.get('schema_path').should.equal "#{process.cwd()}#{path.sep}schemas"
    # @conf.get('trees_path').should.equal "#{process.cwd()}#{path.sep}.rikki-tikki#{path.sep}trees"