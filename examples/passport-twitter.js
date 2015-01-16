var rikkitikki		= require('../lib');
module.exports.RikkiTikkiAPI = rikkitikki;
var express_adapter = require('rikki-tikki-express')
  , express 		= require('express')
  , passport 		= require('passport')
  , util 			= require('util')
  , cookieParser	= require('cookie-parser')
  , bodyParser 		= require('body-parser')
  , methodOverride	= require('method-override')
  , errorhandler 	= require('errorhandler')
  , session      	= require('express-session')
  , logger 			= require('express-logger')
  , TwitterStrategy = require('passport-twitter').Strategy;

var TWITTER_CONSUMER_KEY 	= process.env.TWITTER_CONSUMER_KEY || "--insert-twitter-consumer-key-here--";
var TWITTER_CONSUMER_SECRET = process.env.TWITTER_CONSUMER_SECRET || "--insert-twitter-consumer-secret-here--";

// Server Address and Port can be set from environment variables
var host 		= process.env.HOST || "127.0.0.1";
var port 		= process.env.PORT || "3000";
// Names the log according to environment
var environment = process.env.NODE_ENV || 'development';

// Passport session setup.
//   To support persistent login sessions, Passport needs to be able to
//   serialize users into and deserialize users out of the session.  Typically,
//   this will be as simple as storing the user ID when serializing, and finding
//   the user by ID when deserializing.  However, since this example does not
//   have a database of user records, the complete Twitter profile is serialized
//   and deserialized.
passport.serializeUser(function(user, done) {
  done(null, user);
});

passport.deserializeUser(function(obj, done) {
  done(null, obj);
});


// Use the TwitterStrategy within Passport.
//   Strategies in passport require a `verify` function, which accept
//   credentials (in this case, a token, tokenSecret, and Twitter profile), and
//   invoke a callback with a user object.
passport.use(new TwitterStrategy({
    consumerKey: TWITTER_CONSUMER_KEY,
    consumerSecret: TWITTER_CONSUMER_SECRET,
    callbackURL: "http://"+host+":"+port+"/auth/twitter/callback"
  },
  function(token, tokenSecret, profile, done) {
    // asynchronous verification, for effect...
    process.nextTick(function () {
      
      // To keep the example simple, the user's Twitter profile is returned to
      // represent the logged-in user.  In a typical application, you would want
      // to associate the Twitter account with a user record in your database,
      // and return that user instead.
      return done(null, profile);
    });
  }
));

var app = express();
var router = express.Router();
var adapter = express_adapter.use( router );
var api = new rikkitikki({
	adapter:adapter
});


app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.use(logger({path: "" + __dirname + "/" + environment + ".log"}));
app.use(cookieParser());
app.use(bodyParser());
app.use(methodOverride());
app.use(session({ secret: 'keyboard cat' }));
  // Initialize Passport!  Also use passport.session() middleware, to support
  // persistent login sessions (recommended).
app.use(passport.initialize());
app.use(passport.session());
app.use(express.static(__dirname + '/public'));

router.get('/', function(req, res){
  res.render('index', { user: req.user });
});



router.get('/account', ensureAuthenticated, function(req, res){
  res.render('account', { user: req.user });
});

router.get('/login', function(req, res){
  res.render('login', { user: req.user });
});

// GET /auth/twitter
//   Use passport.authenticate() as route middleware to authenticate the
//   request.  The first step in Twitter authentication will involve redirecting
//   the user to twitter.com.  After authorization, the Twitter will redirect
//   the user back to this application at /auth/twitter/callback
router.get('/auth/twitter',
  passport.authenticate('twitter'),
  function(req, res){
    // The request will be redirected to Twitter for authentication, so this
    // function will not be called.
  });

// GET /auth/twitter/callback
//   Use passport.authenticate() as route middleware to authenticate the
//   request.  If authentication fails, the user will be redirected back to the
//   login page.  Otherwise, the primary route function function will be called,
//   which, in this example, will redirect the user to the home page.
router.get('/auth/twitter/callback', 
  passport.authenticate('twitter', { failureRedirect: '/login' }),
  function(req, res) {
    res.redirect('/');
  });

router.get('/logout', function(req, res){
  req.logout();
  res.redirect('/');
});

app.use('/',router);

app.listen(port, host, function(e,ok) {
	console.log("server is listening at http://"+host+":"+port);
});

//api.getRouter();

// Simple route middleware to ensure user is authenticated.
//   Use this route middleware on any resource that needs to be protected.  If
//   the request is authenticated (typically via a persistent login session),
//   the request will proceed.  Otherwise, the user will be redirected to the
//   login page.
function ensureAuthenticated(req, res, next) {
  if (req.isAuthenticated()) { return next(); }
  res.redirect('/login');
}