DataSourceManager = require '../src/classes/datasource/DataSourceManager'
CollectionMonitor = require '../src/classes/collections/CollectionMonitor'
CollectionManager = require '../src/classes/collections/CollectionManager'
describe 'CollectionManager Test Suite', ->
  before =>
    should()

  it 'should be a Singleton', =>
    @cm = CollectionManager.getInstance()
    (@cm instanceof CollectionManager).should.eq true
    
  it 'should add a collection to the default datasource', (done)=>
    @cm.createCollection 'FooModel', (e,col)=>
      expect(e).to.eq null
      expect(col).to.exist
      done.apply @, arguments

  it 'should List Collections in default Datasource', (done)=>
    @cm.listCollections (e,cols)=>
      expect(e).to.eq null
      cols.length.should.equal 1
      done.apply @, arguments
                
  it 'should remove a collection from the default datasource', (done)=>
    @cm.dropCollection 'FooModel', done

