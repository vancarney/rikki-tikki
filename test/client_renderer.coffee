fs              = require 'fs'
(chai           = require 'chai').should()
RikkiTikkiAPI   = require '../src'
module.exports.RikkiTikkiAPI = RikkiTikkiAPI
ClientRenderer    = require '../src/classes/client/ClientRenderer'

describe 'ClientRenderer Test Suites', ->
  it 'should provide a client', =>
    @renderer = new ClientRenderer
    source = @renderer.toSource()
    console.log source
    source.match(/.*[\s\S]*(var\sNS\s=\sRikkiTikki\.createNameSpace\('Client'\))+/)[1].should.equal "var NS = RikkiTikki.createNameSpace('Client')"
