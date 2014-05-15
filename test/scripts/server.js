var http            = require( 'http' );
var Router          = require( 'routes' );
var request         = require( 'supertest' );
var chai            = require('chai').should();
var RikkiTikkiAPI   = require( '../../lib/api' );
var _               = require('underscore')._;
var adapter 		= null;
global.names 		= ['Products','Orders','Users'];
new RikkiTikkiAPI( "0.0.0.0/client_test", {schema_path:'/Users/van/Documents/workspace/rikki-tikki/test/schemas/product.js'} ).on( 'open', function(e, conn) {
  global.connection = conn;
  global.collectionManager = new RikkiTikkiAPI.CollectionManager( connection );
  _.each( names, function(value,k) {
    collectionManager.createCollection( value, null, function(e,res) {
    	if (e != null)
    		throw Error(e);
   	});
 });
 (global.collections = RikkiTikkiAPI.collectionMon =  new RikkiTikkiAPI.CollectionMonitor( connection ))
 .on( 'init', function() {
	adapter = new (RikkiTikkiAPI.getRoutingAdapter('routes'))( {router: new Router} );
	router 	= new RikkiTikkiAPI.Router( connection, adapter );
	router.intializeRoutes();
	httpServer = http.createServer(adapter.requestHandler);
	httpServer.listen(3006);
 }); 
});


    


exports.adapter = adapter;