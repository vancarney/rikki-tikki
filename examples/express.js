var express 		= require('express');
var RikkiTikkiAPI	= require('../lib/api');
var port = 3000;

global.app = express();

global.api = new RikkiTikkiAPI({
	adapter: RikkiTikkiAPI.createAdapter('express', {app:app}) 
});

app.get('/', function (req,res,next) {
	res.send("<h1>Hello</h1>");
});

app.listen( port );