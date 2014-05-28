express         = require 'express'
request         = require 'supertest'
RikkiTikkiAPI   = require '../src/api'
{_}             = require 'underscore'
module.exports.port = port = 3000
describe 'RikkiTikkiAPI.ExpressAdapter API Test Suite', ->
  @timeout 10000
  it 'should GET all API Routes', (done)=>
    RikkiTikkiAPI.useAdapter 'express', app:express()
    connection = new RikkiTikkiAPI.Connection
    connection.on 'open', (conn) =>
      router = new RikkiTikkiAPI.Router RikkiTikkiAPI.connection = connection, (adapter = RikkiTikkiAPI.getAdapter())
      router.intializeRoutes()
      adapter.params.app.listen port
      _.each names=['test'], (value,k)=>
        request(adapter.params.app)
        .get("#{RikkiTikkiAPI.getAPIPath()}/#{value}")
        .set('Accept', 'application/json')
        .expect('Content-Type', /json/)
        .expect(200, =>
          done() if (k == names.length - 1)
        )
    connection.on 'error', (e)-> console.log e
    connection.connect '0.0.0.0/test'

