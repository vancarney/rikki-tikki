var express 		= require('express');
var RikkiTikkiAPI	= require('../lib');
var Adapter			= require('rikki-tikki-express');
var host			= "0.0.0.0";
var port			= 3000;

global.app 		= express();
global.router	= express.Router();

global.api = new RikkiTikkiAPI({
	adapter: Adapter.use( router ) 
});

router.get('/', function (req,res,next) {
	res.send("<h1>Hello</h1>");
});

app.use( '/', router );

app.listen( port, host, function() {
	console.log("server now listening at http://"+host+":"+port);
} );