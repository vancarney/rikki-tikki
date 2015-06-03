{_}     = require 'lodash'
client  = require 'supertest'

describe 'Model Life Cycle', =>
  it 'should respond to an undefined Model', (done)=>
    client app
    .get '/api/FooModel'
    .expect 'Content-Type', /json/
    .expect 200
    .end (e,res)=>
      throw e if e
      done() if res.body instanceof Array and res.body.length is 0
  it 'should create a new Model from data', (done)=>
    client app
    .post '/api/FooModel'
    .send name: 'Instance 1', value: 1
    .expect 'Content-Type', /json/
    .expect 200
    .end (e,res)=>
      throw e if e
      # console.log arguments
      done() #if res.body instanceof Array and res.body.length is 0    
