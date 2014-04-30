http            = require 'http'
Hapi            = require 'hapi'
request         = require 'supertest'
RikkiTikkiAPI   = require '../lib/api' 
adapter         = new (RikkiTikkiAPI.getRoutingAdapter 'hapi') app:(server = new Hapi.Server '0.0.0.0', 3001)

describe 'RikkiTikkiAPI.HapiAdapter Test Suite', ->
  it 'should start Hapi', (done)=>
    adapter.addRoute('/', 'get', (req,reply)->
      reply name: 'tobias funke'
    )
    server.start => done()
  it 'should perform a basic GET', (done)=>
    req = http.request (
        port:3001
        path:'/'
        method:'GET'
      ), (res)=>
        res.statusCode.should.equal 200
        server.stop()
        done()
    req.end()