(chai           = require 'chai').should()
DataSourceManager = require '../lib/classes/datasource/DataSourceManager'
CollectionMonitor = require '../lib/classes/collections/CollectionMonitor'
CollectionManager = require '../lib/classes/collections/CollectionManager'
describe 'CollectionManager Test Suite', ->
  it 'should be a Singleton', =>
    ((@cm = CollectionManager.getInstance()) instanceof CollectionManager).should.eq true
  it 'should List existing Collections by Datasource Name', =>
    @cm.listCollections('mongo').length.should.equal 0
    @cm.listCollections('db').length.should.equal 0
    
  it 'should maintain List after Collection refresh', (done)=>
    CollectionMonitor.getInstance().refresh =>
      @cm.listCollections('mongo').length.should.equal 0
      @cm.listCollections('db').length.should.equal 0
      done()