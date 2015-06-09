(chai             = require 'chai').should()
{_}               = require 'lodash'
DataSourceManager = require '../lib/classes/datasource/DataSourceManager'
CollectionMonitor = require '../lib/classes/collections/CollectionMonitor'
CollectionManager = require '../lib/classes/collections/CollectionManager'
describe 'CollectionManager Test Suite', ->
  
  it 'should be a Singleton', =>
    ((@cm = CollectionManager.getInstance()) instanceof CollectionManager).should.eq true
    
  it 'should List existing Collections by Datasource Name', (done)=>
    _done = _.after 2, done
    @cm.listCollections 'mongo', (e,cols)=>
      cols.length.should.equal 0
      _done.apply @, arguments
    @cm.listCollections 'db', (e,cols)=>
      cols.length.should.equal 0
      _done.apply @, arguments
    
  it 'should maintain List after Collection refresh', (done)=>
    _done = _.after 2, done
    CollectionMonitor.getInstance().refresh =>
      @cm.listCollections 'mongo', (e,cols)=>
        cols.length.should.equal 0
        _done.apply @, arguments
      @cm.listCollections 'db', (e,cols)=>
        cols.length.should.equal 0
        _done.apply @, arguments