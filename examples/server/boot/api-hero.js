var hero = require('../../../lib');
module.exports = function(app) {
	hero.init(app);	
	var o = {name:"A Model", value:"A Value"};
	var model = app.dataSources.db.buildModelFromInstance( 'MyModel', o, {idInjection: true} );

	var obj = new model(o);
	console.log( obj.toObject() );
	
	model.create( o, function(e,res) {
		console.log(arguments);	
	});
};
