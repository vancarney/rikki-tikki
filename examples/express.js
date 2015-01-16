var express 		= require('express');
var staticPath      = require('serve-static');
var RikkiTikkiAPI	= require('../lib');
var Adapter			= require('rikki-tikki-express');
var host			= "0.0.0.0";
var port			= 3000;

RikkiTikkiAPI.CLIENT_PORT = port;

global.app 		= express();
app.use(staticPath("" + __dirname + "/public"));
app.set('views', '' + __dirname + '/views');
app.set('view engine', 'jade');
global.router	= express.Router();

global.api = new RikkiTikkiAPI({
	adapter: Adapter.use( router )
});

router.get('/', function (req,res,next) {
	res.render('index');
});

app.use( '/', router );

app.listen( port, host, function() {
	console.log("server now listening at http://"+host+":"+port);
} );