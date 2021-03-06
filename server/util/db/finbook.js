var mongoose = require('mongoose');
var schema = mongoose.Schema;
var conf = require('../../conf/serConf.json');
var util = require('../commUtils');
var md5  = require('md5');
var constants = require('../constants');

var dbConnectivityConf = 'mongodb://' + conf.DBHost + '/' + conf.DBName;
var objectId = schema.Types.ObjectId;
var mixedType = schema.Types.Mixed;

var finBookHeaderSchema = new schema({
  finBookId: objectId,
  finBookName: String,
  ownerID: String,
  createDate: Date,
  bookPack: String
});

var finBookBodySchema = new schema({
  recID: objectId,
  createDate: {type: Date , default:Date.now},
  payment: {
    amount: Number,
    currency: {type: String , default: "CNY"},
    loc: String,
    method:{
      pay_method: {type: String},
      pay_info: {type: String}
    }
  },
  amount: Number,
});

var finHeader = mongoose.model('finBookHeader' , finBookHeaderSchema);

exports.createNewFinBook = function(jsonStr , res){
  var finBookInfo = JSON.parse(jsonStr);
  var finBookHeader = new finHeader(finBookInfo);
  util.saveTable("Financial Book" , finBookHeader , res)  
}

exports.createNewRec = function(bookWithName , res){
  //var bookWithName = JSON.parse(jsonStr);
  var bookName = bookWithName.bookName;
  var rec = new Object();
  rec.createDate = bookWithName.date;
  rec.payment = bookWithName.payment;
  rec.amount = bookWithName.amount;
  var finBookModel = mongoose.model(bookName , finBookBodySchema);
  var finBookRec = new finBookModel(rec);
  util.saveTable("Financial Record" , finBookRec , res);
}
