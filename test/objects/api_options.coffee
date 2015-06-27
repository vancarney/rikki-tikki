Hash            = require 'strictly-hash'
describe 'APIOptions Test Suite', ->
  it 'should get APIOptions instance',=>
    (api_options instanceof Hash).should.equal true
  it 'should get schema_path',=>
    api_options.get('schema_path').should.equal "./test/server/common/models"
  it 'should only allow predefined values',=>
    api_options.set 'bogus_value', "__foobar__"
    expect(api_options.get 'bogus_value').to.equal undefined