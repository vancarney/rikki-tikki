DataSourceManager = require '../../lib/classes/datasource/DataSourceManager'
CollectionMonitor = require '../../lib/classes/collections/CollectionMonitor'
CollectionManager = require '../../lib/classes/collections/CollectionManager'
describe 'CollectionManager Test Suite', ->
  before =>
    should()
    # CollectionMonitor.getInstance().refresh =>
      # cols =  CollectionMonitor.getInstance().getCollection()
      # _done = _.after cols.length, done
      # return _done() unless cols.length
      # _.each _.pluck(cols, 'name'), (name)=>
        # CollectionManager.getInstance().dropCollection name, _done

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
      
    
  # it 'should List existing Collections by Datasource Name', (done)=>
    # _done = _.after 2, done
    # @cm.listCollections 'mongo', (e,cols)=>
      # cols.length.should.equal 4
      # _done.apply @, arguments
    # @cm.listCollections 'db', (e,cols)=>
      # cols.length.should.equal 0
      # _done.apply @, arguments
#     
  # it 'should maintain List after Collection refresh', (done)=>
    # _done = _.after 2, done
    # CollectionMonitor.getInstance().refresh =>
      # @cm.listCollections 'db', (e,cols)=>
        # cols.length.should.equal 0
        # _done.apply @, arguments
      # @cm.listCollections 'mongo', (e,cols)=>
        # cols.length.should.equal 4
        # _done.apply @, arguments
