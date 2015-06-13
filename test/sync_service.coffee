(chai           = require 'chai').should()
fs              = require 'fs'
path            = require 'path'
client          = require 'supertest'
SyncService     = require '../lib/classes/services/SyncService'
DataSource      = require '../lib/classes/datasource/DataSource'
return
# describe 'SyncService Class Test Suite', ->
  # @timeout 15000
  # name = 'SyncTestCollection'
# 
  # it 'should create Schemas and Schema Trees', (done)=>
    # fs.unlinkSync f if fs.existsSync f = "#{api_options.get 'trees_path'}#{path.sep}#{name}.json"
    # client app
    # .post "/api/#{name}"
    # .send name: 'Instance 1', value: 1
    # .expect 'Content-Type', /json/
    # .expect 200
    # .end (e,res)=>
      # throw e if e
      # console.log DataSource.getDataSource('mongo').listCollections()
      # # console.log arguments
      # setTimeout (=>
        # fs.exists (p = "#{api_options.get 'schema_path'}#{path.sep}#{name}.js"), (exists)=> 
          # done() if exists
      # ), 1500
#       
  # it 'should tear down our testing env', (done)=>
    # setTimeout (=>
      # f = "#{api_options.get 'schema_path'}/_#{name}.js"
      # unless fs.existsSync f
        # fs.unlinkSync "#{api_options.get 'trees_path'}#{path.sep}#{name}.json"
        # fs.unlinkSync "#{api_options.get 'schema_path'}#{path.sep}#{name}.js"
        # throw "Collection '#{name}' was not destroyed (non-destructively) by SyncManager"
      # fs.unlinkSync f
      # done()
    # ), 3000
    
    # @colManager.dropCollection 'TestSchema', (e,col)=>
      # fs.unlink f if fs.existsSync f = '../.rikki-tikki/trees/TestSchema.json'
          