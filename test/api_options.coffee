{_}             = require 'lodash'
path            = require 'path'
(chai           = require 'chai').should()
expect          = chai.expect
Hash            = require 'strictly-hash'
describe 'APIOptions Test Suite', ->
  it 'should get APIOptions instance',=>
    (api_options instanceof Hash).should.equal true
  it 'should get schema_path',=>
    api_options.get('schema_path').should.equal "#{process.cwd()}#{path.sep}schemas"
  it 'should maintain discrete values in both hashes',=>
    api_options.set 'schema_path', "#{process.cwd()}#{path.sep}__foobar__"
    api_options.get('schema_path').should.equal "#{process.cwd()}#{path.sep}schemas"
    # @conf.get('trees_path').should.equal "#{process.cwd()}#{path.sep}.rikki-tikki#{path.sep}trees"