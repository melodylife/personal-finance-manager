var express = require('express');
var router = express.Router();
var finBook = require('../util/db/finbook');

router.post('/saveFinRec', function(req, res) {
  /*var userID = req.query.userid;
  var password = req.query.password;
  userInfo.login(userID , password , res);*/

  console.log('Here\'s the saving fin book ' + req.body);
  var rawBody = JSON.parse(req.body);
  var bookRecWithName = new Object();
  bookRecWithName.bookName = rawBody.bookName;
  bookRecWithName.newRec = rawBody.bookName;
  finBook.createNewRec(bookRecWithName , res);
});

module.exports = router;
