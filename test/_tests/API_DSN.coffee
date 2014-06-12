fs              = require 'fs'
(chai           = require 'chai').should()
RikkiTikkiAPI   = require '../src/api'
describe 'RikkiTikkiAPI.DSN Test Suite', ->
  @dsn = new RikkiTikkiAPI.DSN
  it 'should accept a new DSN String', =>
    @dsn.setDSN '0.0.0.0'
    @dsn.getDSN().should.be.a 'Object'
    @dsn.getDSN().host.should.equal '0.0.0.0'
  it 'should accept a protocol in the String', =>
    @dsn.setDSN 'mongodb://0.0.0.0'
    @dsn.getDSN().should.be.a 'Object'
    @dsn.getDSN().protocol.should.equal 'mongodb'
    @dsn.getDSN().host.should.equal '0.0.0.0'
  it 'should accept a port in the String', =>
    @dsn.setDSN 'mongodb://0.0.0.0:27017' #
    @dsn.getDSN().should.be.a 'Object'
    @dsn.getDSN().protocol.should.equal 'mongodb'
    @dsn.getDSN().host.should.equal '0.0.0.0'
    @dsn.getDSN().port.should.equal 27017
  it 'should accept a username in the String', =>
    @dsn.setDSN 'mongodb://user@0.0.0.0:27017' 
    @dsn.getDSN().should.be.a 'Object'
    @dsn.getDSN().protocol.should.equal 'mongodb'
    @dsn.getDSN().host.should.equal '0.0.0.0'
    @dsn.getDSN().port.should.equal 27017
    @dsn.getDSN().username.should.equal 'user'
  it 'should accept a password in the String', =>
    @dsn.setDSN 'mongodb://user:password@0.0.0.0:27017' 
    @dsn.getDSN().should.be.a 'Object'
    @dsn.getDSN().protocol.should.equal 'mongodb'
    @dsn.getDSN().host.should.equal '0.0.0.0'
    @dsn.getDSN().username.should.equal 'user'
    @dsn.getDSN().password.should.equal 'password'
  it 'should accept a database in the String', =>
    @dsn.setDSN 'mongodb://user:password@0.0.0.0:27017/mydb' 
    @dsn.getDSN().should.be.a 'Object'
    @dsn.getDSN().protocol.should.equal 'mongodb'
    @dsn.getDSN().host.should.equal '0.0.0.0'
    @dsn.getDSN().username.should.equal 'user'
    @dsn.getDSN().password.should.equal 'password'
    @dsn.getDSN().database.should.equal 'mydb'
  it 'should accept options in the String', =>
    @dsn.setDSN 'mongodb://user:password@0.0.0.0:27017/mydb?ssl=true&connectTimeoutMS=2000'
    @dsn.getDSN().should.be.a 'Object'
    @dsn.getDSN().protocol.should.equal 'mongodb'
    @dsn.getDSN().host.should.equal '0.0.0.0'
    @dsn.getDSN().username.should.equal 'user'
    @dsn.getDSN().password.should.equal 'password'
    @dsn.getDSN().database.should.equal 'mydb'   
    @dsn.getDSN().options.should.be.a 'Object'
    @dsn.getOptions().getSSL().should.equal true
    @dsn.getOptions().getConnectTimeoutMS().should.equal 2000
  it 'should accept replicas in the String', =>
    @dsn.setDSN 'mongodb://user:password@0.0.0.0:27017,db.host2:27017,db.host3:2701/mydb?ssl=true&connectTimeoutMS=2000'
    @dsn.getDSN().should.be.a 'Object'
    @dsn.getDSN().protocol.should.equal 'mongodb'
    @dsn.getDSN().host.should.equal '0.0.0.0'
    @dsn.getDSN().username.should.equal 'user'
    @dsn.getDSN().password.should.equal 'password'
    @dsn.getDSN().database.should.equal 'mydb'
    @dsn.getDSN().options.should.be.a 'Object'
    @dsn.getOptions().getSSL().should.equal true
    @dsn.getOptions().getConnectTimeoutMS().should.equal 2000
    @dsn.getDSN().replicas.should.be.a 'Array'
    @dsn.getDSN().replicas.length.should.equal 2
    @dsn.getDSN().replicas[0].host.should.equal 'db.host2'
    @dsn.getDSN().replicas[1].host.should.equal 'db.host3'