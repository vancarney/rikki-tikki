{_}               = require 'lodash'
{should,expect}   = require 'chai'
DataSourceManager = require '../lib/classes/datasource/DataSourceManager'

describe 'DataSource Test Suite', ->
  before =>
    should()
    @dsMan = DataSourceManager.getInstance()
    
  it 'should obtain the db datasource',=>
    (@db = @dsMan.getDataSource 'db').should.not.eq null
    # console.log @db.connector
    # db.collections (e,cols)-> console.log _.map _.pluck( cols, 's'), (v)-> v.name
    # (@db instanceof DataSource).should.eq true
  it 'should obtain the mongo datasource',=>
    (@mongo = @dsMan.getDataSource 'mongo').should.not.eq null
    
  it 'should have connected to the mongo datasource',=>
    @mongo.connected.should.eq true
    
  it 'should have added the ApiHero mixin to the mongo datasource',=>
    expect(@mongo.ApiHero).to.exist
    
  it 'should obtain the MySQL datasource',=>
    (@mysql = @dsMan.getDataSource 'mysql').should.not.eq null
    # #.db.collections (e,cols)-> console.log _.map _.pluck( cols, 's'), (v)-> v.name
    # (@mysql instanceof DataSource).should.eq true
    
  # it 'should list db collections',=>
    # @db.listCollections().length.should.equal 0
  # it 'should list mongo collections',=>
    # @db.listCollections().length.should.equal 0
    
  # it 'should detect MySQL Tables', (done)=>
    # @mysql.connector.discoverModelDefinitions {schema:'rikki-tikki'}, (e,res)=>
      # throw e if e?
      # (_.pluck res, 'name').length.should.eq 2
      # done()
