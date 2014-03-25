var express = require('express');
var RikkiTikkiAPI = require('../../lib/api').RikkiTikkiAPI;
var port = 3000;
global.api = new RikkiTikkiAPI();
api.connect( '0.0.0.0' );

global.app = express();
app.listen(port);
app.get('/', function(req,res,next) {
	console.log("get");
});
api.registerApp(app);