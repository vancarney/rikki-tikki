var express 		= require('express');
var RikkiTikkiAPI	= require('../lib/api');
var mongoose		= require('mongoose');
var port 			= 3000;

global.app = express();

global.api = new RikkiTikkiAPI({
	schema_path:'./mongoose-schemas',
	adapter:RikkiTikkiAPI.createAdapter('express', {app:app}) 
});


app.listen( port );
app.get('/', function(req,res,next) {
	res.send("<h1>Hello</h1>");
});