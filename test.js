var MongoClient = require('mongodb').MongoClient
, ObjectID = require('mongodb').ObjectID
, format 		= require('util').format;

MongoClient.connect('mongodb://127.0.0.1:27017/admin', function(err, db) {
    if(err) throw err;

    var collection = db.collection('item');
    // collection.insert({a:2}, function(err, docs) {
//       
      // collection.count(function(err, count) {
        // console.log(format("count = %s", count));
      // });

      // Locate all the entries using find
      collection.find({_id:new ObjectID("55185c5bf8d11dfc95bc309a")}).toArray(function(err, results) {
        console.dir(results);
        // Let's close the db
        db.close();
      });
    // });
});