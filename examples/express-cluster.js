var express 		= require('express');
var cluster 		= require('cluster');
var cpus			= require('os').cpus;
var RikkiTikkiAPI	= require('../lib');
var port = 3000;

if (cluster.isMaster) {
	fork = function() {
		if (cluster) { return cluster.fork(); }
	};
	
	for (core = _i = 1, _ref2 = cpus().length; 1 <= _ref2 ? _i <= _ref2 : _i >= _ref2; core = 1 <= _ref2 ? ++_i : --_i) {
    	fork();
	}
	
	cluster.on('exit', function(worker, code, signal) {
    	return console.error( "worker " + worker.process.pid + " died");
	});
	
	cluster.on('disconnect', function(worker) {
    	return fork();
	});
} 

else {
	global.app = express();
	
	global.api = new RikkiTikkiAPI({
		adapter:RikkiTikkiAPI.createAdapter('express', {app:app}) 
	});

	app.get('/', function (req,res,next) {
		res.send("<h1>Hello</h1>");
	});	

	// http.createServer(app).listen(port);
	app.listen(port, (function() {
    	return console.log("\u001b[32mExpress Service available at: \u001b[36mhttp://0.0.0.0:" + port + "\u001b[0m");
	}));
}