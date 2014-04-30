var express 		= require('express');
var RikkiTikkiAPI	= require('../../lib/api');
var mongoose		= require('mongoose');
var port 			= 3000;

global.api = new RikkiTikkiAPI();
global.app = express();

api.connect( '0.0.0.0/demo', {
	open:function(evt) { 
		console.log('connection opened'); 
	},
	
	close:function(evt) { 
		console.log('connection closed');
	},
	
	error:function(e) { 
		console.error(e); 
		process.exit(1);
	}
});

app.listen( port );
app.get('/', function(req,res,next) {
	console.log("get");
});

api.registerApp(app);