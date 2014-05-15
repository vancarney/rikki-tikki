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

module.exports = products;