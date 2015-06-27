Collection        = require '../../lib/classes/collections/Collection'
CollectionManager = require '../../lib/classes/collections/CollectionManager'
describe 'Collection Test Suite', ->
  before =>
    should()
    @cm = CollectionManager.getInstance()
    
  it 'should add a collection to the default datasource', (done)=>
    Collection.create 'FooModel', =>
      @cm.getCollection 'FooModel', (e,@col)=>
        expect(@col).to.exist
        done.apply @, arguments
 
  it 'should rename a collection', (done)=>
    @col.rename 'RenamedModel', =>
      @cm.getCollection 'RenamedModel', (e,col)=>
        expect(col).to.exist
        done.apply @, arguments
        
  it 'should remove a collection from the default datasource', (done)=>
    @col.drop =>
      @cm.getCollection 'RenamedModel', (e,col)=>
        expect(col).to.not.exist
        e.should.eq 'collection not found'
        done()
        
  after (done)=>
    process.nextTick done

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
