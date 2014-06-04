var RikkiTikkiAPI = require('../../lib/api');
var products = new RikkiTikkiAPI.Schema({
	sku:Number,
	name:String,
	description:String,
	price:Number
});

products.virtuals.short_desc = function() {
	return (arr = this.description.substr(0, 50).split(' ')).slice(0, arr.length-2);
};

products.validators = {};

products.validators.sku = function(value) {
	return value > 1000 && value < 10000;
};

products.validators.name = function(value) {
	return typeof value === 'string';
};

products.validators.description = function(value) {
	return typeof value === 'string';
};

products.validators.price = function(value) {
	return typeof value === 'number';
};


module.exports = new RikkiTikkiAPI.model( 'products',  products );