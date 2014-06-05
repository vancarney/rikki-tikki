express         = require 'express'
request         = require 'supertest'
RikkiTikkiAPI   = require '../src/api'
{_}             = require 'underscore'
module.exports.port = port = 3000

describe 'RikkiTikkiAPI.ExpressAdapter API Test Suite', ->
  @app     = express()
  @adapter = RikkiTikkiAPI.createAdapter 'express', app:@app
  it 'should GET all API Routes', (done)=>
    new RikkiTikkiAPI {
      config_path: './test/configs'
      schema_path: './test/schemas'
      adapter: @adapter
    }, (e,result)=>
      return throw e if e?
      RikkiTikkiAPI.Router.getInstance().intializeRoutes()
      
      _.each names=['products'], (value,k)=>
        request(@app)
        .get("api/1/#{value}")
        .set('Accept', 'application/json')
        .expect('Content-Type', /json/)
        .expect(200, =>
          done() if (k == names.length - 1)
        )
        
  @app.listen port