var express 		= require('express');
var RikkiTikkiAPI	= require('../lib');
var Adapter			= require('express-adapter');
var port = 3000;

global.app = express();

global.api = new RikkiTikkiAPI({
	adapter: new Adapter( {app:app} ) 
});

app.get('/', function (req,res,next) {
	res.send("<h1>Hello</h1>");
});

app.listen( port );