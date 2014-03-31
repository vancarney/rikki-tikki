http            = require 'http'
express          = require 'express'
request         = require 'supertest'
RikkiTikkiAPI   = require( '../lib/api' ).RikkiTikkiAPI
adapter    = new RikkiTikkiAPI.ExpressAdapter app:express()
describe 'RikkiTikkiAPI.ExpressAdapter Test Suite', ->
  # it 'should add a route', =>
    adapter.addRoute('/', 'get', (req,res)->
      res.setHeader 'Content-Type', 'application/json'
      res.send 200, name: 'tobias funke'
    )
    adapter.params.app['get'].should.be.a 'Function'
    # adapter.router.router.match('/').should.be.a 'Object'
    # adapter.params.router.match('/').fn.GET.should.be.a 'Function'
  it 'should perform a basic GET', (done)=>
    request(adapter.params.app)
    .get('/')
    .set('Accept', 'application/json')
    .expect('Content-Type', /json/)
    .expect(200, =>
      done()
      # super_done()
    )