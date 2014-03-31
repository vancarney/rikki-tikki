express         = require 'express'
request         = require 'supertest'
RikkiTikkiAPI   = require( '../../lib/api' ).RikkiTikkiAPI
_               = require('underscore')._
describe 'RikkiTikkiAPI.ExpressAdapter API Test Suite', ->
  @timeout 10000
  it 'should GET all API Routes', (done)=>
    adapter    = new RikkiTikkiAPI.ExpressAdapter app:express()
    router     = new RikkiTikkiAPI.Router adapter.params.app, collections.getNames(), adapter
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