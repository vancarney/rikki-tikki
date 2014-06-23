var express 		= require('express');
var passport 		= require('passport');
var cookieParser	= require('cookie-parser');
var session      	= require('express-session');
var RikkiTikkiAPI   = require( '../../lib' );
var port = 3000;

global.app = express();

app.use(cookieParser());
app.use(session({secret:"12345674564565465"}));

app.use(passport.initialize());
app.use(passport.session());

global.api = new RikkiTikkiAPI({
	config_path:'/Users/van/Documents/workspace/rikki-tikki/test/scripts/configs',
	schema_path:'/Users/van/Documents/workspace/rikki-tikki/test/scripts/schemas',
	auth_config_path:'/Users/van/Documents/workspace/rikki-tikki/test/scripts/configs/auth',
	adapter: RikkiTikkiAPI.createAdapter('express', {app:app}) 
});

app.get('/', function (req,res,next) {
	res.send("<h1>Hello</h1>");
});

app.listen( port );