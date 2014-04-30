fs              = require 'fs'
path            = require 'path'
(chai           = require 'chai').should()
request         = require 'supertest'
RikkiTikkiAPI   = require '../src/api'
describe 'RikkiTikkiAPI.Router Test Suite', ->
  # @url      = 'http://0.0.0.0:3002'
  # @api_path = "#{RikkiTikkiAPI.getAPIPath()}/index"
  # it 'should have API Index Routes', (done)=>
    # request(@url)
    # .get(@api_path)
    # .end((e, res)=>
      # console.log e if e?
      # res.should.have.status 200
      # done()
    # )