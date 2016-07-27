DataSourceManager = require '../../lib/classes/datasource/DataSourceManager'

describe 'DataSource Test Suite', ->
  before =>
    should()
    @dsMan = DataSourceManager.getInstance()
    
  it 'should obtain the db datasource',=>
    (@db = @dsMan.getDataSource 'db').should.not.eq null

  it 'should obtain the mongo datasource',=>
    (@mongo = @dsMan.getDataSource 'mongo').should.not.eq null
    
  it 'should have connected to the mongo datasource',=>
    @mongo.connected.should.eq true
    
  it 'should have added the ApiHero mixin to the mongo datasource',=>
    expect(@mongo.ApiHero).to.exist
    
  it 'should obtain the MySQL datasource',=>
    (@mysql = @dsMan.getDataSource 'mysql').should.not.eq null
    
  it 'should create a collection', (done)=>
    @mongo.ApiHero.createCollection 'FooModel', =>
      setTimeout done, 600

  it 'should list mongo collections',(done)=>
    @mongo.ApiHero.listCollections (e,cols)=>
      cols.length.should.equal 2
      done.apply @, arguments


  it 'should drop a collection', (done)=>
    @mongo.ApiHero.dropCollection 'FooModel', =>
      setTimeout (=>
        @mongo.ApiHero.listCollections (e,cols)=>
          (0 <= cols.indexOf 'FooModel').should.eq false
          done.apply @, arguments
        ), 600
       # console.log arguments
       # done.apply @, arguments
    # @mongo.collections 'FooModel', =>
      # console.log arguments
      # done()
