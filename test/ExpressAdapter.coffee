express         = require 'express'
request         = require 'supertest'
RikkiTikkiAPI   = require '../src/api'
{_}             = require 'underscore'
describe 'RikkiTikkiAPI.ExpressAdapter API Test Suite', ->
  @timeout 10000
  it 'should GET all API Routes', (done)=>
    adapter    = new (RikkiTikkiAPI.getRoutingAdapter 'express') app:express()
    connection = new RikkiTikkiAPI.Connection
    connection.on 'open', (conn) =>
      router = new RikkiTikkiAPI.Router RikkiTikkiAPI.connection = connection, adapter
      router.intializeRoutes()
      adapter.params.app.listen 3000
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