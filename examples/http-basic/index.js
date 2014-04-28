var http = require( 'http' );
var RikkiTikkiAPI = require('../../lib/api');
var port = 3000;
var _ = require('underscore')._;

// global.app = http
global.api = new RikkiTikkiAPI();
api.connect( '0.0.0.0' );