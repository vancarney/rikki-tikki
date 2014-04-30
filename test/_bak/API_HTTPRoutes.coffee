http            = require 'http'
Routes          = require 'routes'
request         = require 'supertest'
chai            = require('chai').should()
RikkiTikkiAPI   = require '../src/api' 
_               = require('underscore')._
client          = require('../lib/client').RikkiTikki
adapter         = new (RikkiTikkiAPI.getRoutingAdapter 'routes') router:new Routes
httpServer      = http.createServer adapter.requestHandler
httpServer.listen 3002
global.names    = ['Products','Orders','Users']
describe 'HTTP API Routes Test Suite', ->
  @timeout 10000
  it 'should setup Collections', (done)=>
    @connection = new RikkiTikkiAPI.Connection '0.0.0.0/http_test',
      open: (conn)=>
        RikkiTikkiAPI.connection = conn
        @collectionManager = new RikkiTikkiAPI.CollectionManager conn#ection
        RikkiTikkiAPI.collectionMon = new RikkiTikkiAPI.CollectionMonitor conn
        _.each names, (name,k)=>
          @collectionManager.createCollection name, (e,res)=>
            console.error e if e?
            done() if res? and k == (names.length - 1)
     error: (e)-> console.error e
  it 'should get Collections list', (done)->
    (global.collections = new RikkiTikkiAPI.CollectionMonitor RikkiTikkiAPI.connection
    ).on 'init', => done()
  it 'should complete all API calls', (done)=>
    # adapter    = new RikkiTikkiAPI.RoutesAdapter app:httpServer
    router     = new RikkiTikkiAPI.Router RikkiTikkiAPI.connection, adapter
    router.intializeRoutes()
    _.each names, (value,k)=>
      request httpServer
      .get("#{RikkiTikkiAPI.getAPIPath()}/#{value}")
      .set('Accept', 'application/json')
      .expect('Content-Type', /json/)
      .expect(200, =>
        # console.log arguments
        done() if (k == names.length - 1)
      )
  it 'should teardown Collections', (done)=>
    _.each names, (value,k)=>
      @collectionManager.dropCollection value, (e,res) =>
        console.log e if e?
        if res? and k == (names.length - 1)
          @connection.close()
          done()