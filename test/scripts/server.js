var http            = require( 'http' );
var Router          = require( 'routes' );
var RikkiTikkiAPI   = require( '../../lib' );

new RikkiTikkiAPI({
	config_path:'/Users/van/Documents/workspace/rikki-tikki/test/scripts/configs',
	schema_path:'/Users/van/Documents/workspace/rikki-tikki/test/scripts/schemas',
	auth_config_path:'/Users/van/Documents/workspace/rikki-tikki/test/scripts/configs/auth',
	adapter: RikkiTikkiAPI.createAdapter( 'routes', {router: new Router()} )
}, function (e,results) {
	if (e == null) {
		console.log('starting server');
		httpServer = http.createServer(RikkiTikkiAPI.getAdapter().requestHandler);
		httpServer.listen(3006);	
	} else {
		console.error( e );
	}
});



// .on( 'open', function(e, conn) {
  // global.connection = conn;
  // global.collectionManager = new RikkiTikkiAPI.CollectionManager( connection );
  // _.each( names, function(value,k) {
    // collectionManager.createCollection( value, null, function(e,res) {
    	// if (e != null)
    		// throw Error(e);
   	// });
 // });
 // (global.collections = RikkiTikkiAPI.collectionMon =  new RikkiTikkiAPI.CollectionMonitor( connection ))
 // .on( 'init', function() {
	// RikkiTikkiAPI.useAdapter( 'routes', {router: new Router()} );
	// // router 	= RikkiTikkiAPI.Router.getInstance();
	// // router.intializeRoutes();
	// httpServer = http.createServer(RikkiTikkiAPI.getAdapter().requestHandler);
	// httpServer.listen(3006);
 // }); 
// });