var http			= require( 'http' );
var _ 				= require('underscore')._;
var Router			= require( 'routes' );
var RikkiTikkiAPI	= require('../../lib/api');
var port 			= 3000;

var connection = (global.api = new RikkiTikkiAPI).connect( '0.0.0.0/demo', { 
	open: function(conn) {
		var adapter = new (RikkiTikkiAPI.getRoutingAdapter('routes'))( {router: new Router} );
		var router 	= new RikkiTikkiAPI.Router( conn, adapter );
		router.intializeRoutes();
		httpServer = http.createServer( adapter.requestHandler );
		httpServer.listen( port );
	},
	
	error: function(e) {
		console.error("could not start service\n"+e);
	}
});
