express         = require 'express'
request         = require 'supertest'
RikkiTikkiAPI   = require '../src/api'
{_}             = require 'underscore'
describe 'RikkiTikkiAPI.ExpressAdapter API Test Suite', ->
  @timeout 10000
  it 'should GET all API Routes', (done)=>
    adapter    = new (RikkiTikkiAPI.getRoutingAdapter 'ExpressAdapter') app:express()
    # collections = collections.getNames()
    collections = {}
    router     = new RikkiTikkiAPI.Router adapter.params.app, collections, adapter
    router.intializeRoutes()
    adapter.params.app.listen 3000
    _.each names, (value,k)=>
      request(adapter.params.app)
      .get("#{RikkiTikkiAPI.getAPIPath()}/#{value}")
      .set('Accept', 'application/json')
      .expect('Content-Type', /json/)
      .expect(200, =>
        done() if (k == names.length - 1)
      )