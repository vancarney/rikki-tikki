var http            = require( 'http' );
var Router          = require( 'routes' );
var request         = require( 'supertest' );
var chai            = require('chai').should();
var RikkiTikkiAPI   = require( '../../lib/api' ).RikkiTikkiAPI;
var _               = require('underscore')._;
var adapter 		= null;
global.names 		= ['Products','Orders','Users'];

global.connection = new RikkiTikkiAPI.Connection( "0.0.0.0/client_test" );
connection.once( 'open', function(e) {
  global.collectionManager = new RikkiTikkiAPI.CollectionManager( connection );
  _.each( names, function(value,k) {
    collectionManager.createCollection( value, null, function(e,res) {
    	if (e != null)
    		throw Error(e);
   	});
 });
 (global.collections = new RikkiTikkiAPI.CollectionMonitor( connection.getMongoDB() ))
 .on( 'init', function() {
	adapter = new RikkiTikkiAPI.RoutesAdapter( {router: new Router} );
	adapter.setApp( http.createServer( adapter.requestHandler) );
	router 	= new RikkiTikkiAPI.Router( connection, collections.getNames(), adapter );
	router.intializeRoutes();
	adapter.params.app.listen( 3000 );
 }); 
});


    


exports.adapter = adapter;