var express 		= require('express');
var staticPath      = require('serve-static');
var API				= require('../lib');
var Adapter			= require('rikki-tikki-express');
var host			= "0.0.0.0";
var port			= 3000;

API.CLIENT_PORT = port;
API.SCHEMA_API_REQUIRE_PATH = '../../lib';

global.app = express();
app.use(staticPath('' + __dirname + '/public'));
app.set('views', '' + __dirname + '/views');
app.set('view engine', 'jade');

global.api = new API({
	adapter: Adapter.use( app )
});

app.get('/', function (req,res,next) {
	res.render('index');
});

app.listen( port, host, function() {
	console.log("server now listening at http://"+host+":"+port);
} );