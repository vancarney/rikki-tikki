mongo-dsn
=========

[![Build Status](https://travis-ci.org/vancarney/mongo-dsn.png)](https://travis-ci.org/vancarney/mongo-dsn)
[![NPM Version](http://img.shields.io/npm/v/mongo-dsn.svg)](https://www.npmjs.org/package/mongo-dsn)

DSN Utility for MongoDB

 * Supports `NODE_ENV` for environment based configs
 * Supports a flat config for generic config regardless of environment


Usage
-----------

*configs/db.json*
```
{
  "development":{
    "username":"devel",
    "password":"password",
    "protocol":"mongodb",
    "host":"0.0.0.0",
    "port": 27017,
    "database":"develop"
  },
  "test":{
    "username":"test",
    "password":"password",
    "protocol":"mongodb",
    "host":"0.0.0.0",
    "port": 27017,
    "database":"testing"
  },
  "production":{
    "username":"prod",
    "password":"password",
    "protocol":"mongodb",
    "host":"mongohost.domain.com",
    "port": 27017,
    "database":"production"
  }
}
```

*load the config file and connect*
```
DSN.loadConfig(""+__dirname+"/configs/db.json", function (e,dsn) {
	dbConnector.invokeDBConnection( dsn.toDSN() );
});
```


Events
-----------

#### error
emitted if configuration fails validation



Methods
-----------

#### DSN(mixed)
Constructs a new DSN Object from a String or JS Object
returns new DSN

#### loadConfig(path, callback)
Attempts to load and parse a Config file
invokes callback with 'error' and 'dsn' params containing error or new DSN respectively

#### toJSON()
returns the JS Object representation

#### toDSN()
returns the DSN String representation usable by a MongoDB connector

#### toString()
alias of `toDSN`