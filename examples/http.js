var http			= require( 'http' );
var _ 				= require('underscore')._;
var Router			= require( 'routes' );
var RikkiTikkiAPI	= require('../lib');
var port 			= 3000;
var adapter			= RikkiTikkiAPI.createAdapter('routes', {router: new Router});
global.api = new RikkiTikkiAPI({
	adapter:adapter
}, function (e, ok) { 
	if (e != null) 
		return console.error("Could not start API service\n"+e);
});

httpServer = http.createServer( adapter.requestHandler );
httpServer.listen( port );

adapter.params.router.addRoute('/', function (req,res,next) {
	res.end('<h1>Hello</h1');
});
