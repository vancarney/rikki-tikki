(chai           = require 'chai').should()
fs              = require 'fs'
SyncService     = require '../lib/classes/services/SyncService'

describe 'SyncService Class Test Suite', ->
  @timeout 15000
  name = 'SyncTestCollection'
  it 'should create Schemas and Schema Trees', (done)=>
    fs.unlinkSync f if fs.existsSync f = "./.rikki-tikki/trees/#{name}.json"
    setTimeout (=>
      fs.exists (p = "#{api_options.get 'schema_path'}/#{name}.js"), (exists)=> 
        done() if exists
    ), 1500
  it 'should tear down our testing env', (done)=>
    setTimeout (=>
      f = "#{api_options.get 'schema_path'}/_#{name}.js"
      unless fs.existsSync f
        fs.unlinkSync ".rikki-tikki/trees/#{name}.json"
        fs.unlinkSync "#{api_options.get 'schema_path'}/#{name}.js"
        throw "Collection '#{name}' was not destroyed (non-destructively) by SyncManager"
      fs.unlinkSync f
      done()
    ), 3000
    
    # @colManager.dropCollection 'TestSchema', (e,col)=>
      # fs.unlink f if fs.existsSync f = '../.rikki-tikki/trees/TestSchema.json'
          