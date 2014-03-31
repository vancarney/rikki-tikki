express         = require 'express'
request         = require 'supertest'
chai            = require('chai').should()
RikkiTikkiAPI   = require( '../lib/api' ).RikkiTikkiAPI
_               = require('underscore')._
client          = require('../lib/client').RikkiTikki
global.names = ['Products','Orders','Users']
describe 'Express API Routes Test Suite', ->
  @timeout 10000
  it 'should setup Collections', (done)=>
    global.connection = new RikkiTikkiAPI.Connection "0.0.0.0/test"
    connection.once 'open', (e)=>
      global.collectionManager = new RikkiTikkiAPI.CollectionManager connection
      _.each names, (value,k)=>
        collectionManager.createCollection value, null, (e,res) =>
          console.log e if e?
          done() if res? and k == (names.length - 1)
  it 'should get Collections list', (done)->
    (global.collections = new RikkiTikkiAPI.CollectionMonitor connection.getMongoDB()
    ).on 'init', => done()
  it 'should complete all API calls', (done)=>
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
        # console.log arguments
        done() if (k == names.length - 1)
      )

    
  it 'should teardown Collections', (done)=>
    _.each names, (value,k)=>
      collectionManager.dropCollection value, (e,res) =>
        console.log e if e?
        if res? and k == (names.length - 1)
          connection.close()
          done()