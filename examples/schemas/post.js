var RikkiTikkiAPI	= require('../../lib');
var Schema 			= Object;

var postSchema = new Schema({
  title:  String,
  author: String,
  body:   String,
  comments: [{ body: String, date: Date }],
  date: { type: Date, default: Date.now },
  hidden: Boolean,
  meta: {
    votes: Number,
    favs:  Number
  }
});

module.exports = postSchema //RikkiTikkiAPI.model( 'post', postSchema );