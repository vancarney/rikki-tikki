var mongoose	= require('mongoose');
var Schema 		= mongoose.Schema;

var likeSchema = new Schema({
  post_id: String,
  user_ids: []
});

module.exports = likeSchema;
//var likeModel = mongoose.model('likings', likeSchema);
//module.exports = likeModel;