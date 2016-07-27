(chai           = require 'chai').should()
fs              = require 'fs'
path            = require 'path'
client          = require 'supertest'
DataSource      = require '../lib/classes/datasource/DataSource'
CollectionManager      = require '../lib/classes/collections/CollectionManager'
describe 'SyncService Class Test Suite', ->
  @timeout 15000
  name = 'SyncTestCollection'
  newName = 'RenamedTestCollection'
  before =>
    fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'trees_path'}#{path.sep}#{name}.json"
    fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'trees_path'}#{path.sep}#{name}.json"
    fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'schema_path'}#{path.sep}#{name}.js"  
      
  it 'should init SyncItems', =>
    app.ApiHero.SyncService.getInstance().listSyncKinds().length.should.eq 2
  it 'should create Schemas and Schema Trees', (done)=>
    ival = setInterval (=>
      fs.exists (p = "#{api_options.get 'schema_path'}#{path.sep}#{name}.js"), (exists)=>
        if exists
          clearInterval ival
          done() 
    ), 250
    client app
    .post "/api/#{name}"
    .send name: 'Instance 1', value: 1
    .expect 'Content-Type', /json/
    .expect 200
    .end (e,res)=>
      done e if e
  # it 'should rename schemas', (done)=>
    # CollectionManager.getInstance().renameCollection name, newName, (e)=>
      # return done e if e?
      # f = "#{api_options.get 'schema_path'}/#{newName}.js"
      # ival = setInterval (=>
        # if fs.existsSync f
          # clearInterval ival 
          # done() 
      # ), 300
  it 'should non-destructively remove schema', (done)=>
    CollectionManager.getInstance().dropCollection name, (e)=>
      return done e if e?
      f = "#{api_options.get 'schema_path'}/_#{name}.js"
      ival = setInterval (=>
        if fs.existsSync f
          clearInterval ival 
          done() 
      ), 300
  after =>
    fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'trees_path'}#{path.sep}#{name}.json"
    fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'trees_path'}#{path.sep}#{name}.json"
    fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'schema_path'}#{path.sep}#{name}.js"
    fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'trees_path'}#{path.sep}#{newName}.json"
    fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'trees_path'}#{path.sep}#{newName}.json"
    fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'schema_path'}#{path.sep}#{newName}.js"          