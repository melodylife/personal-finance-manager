var mongoose = require('mongoose');
var schema = mongoose.Schema;
var conf = require('../../conf/serConf.json');
var util = require('../commUtils');
var md5  = require('md5');
var constants = require('../constants');

var dbConnectivityConf = 'mongodb://' + conf.DBHost + '/' + conf.DBName

mongoose.connect(dbConnectivityConf);

var userInfoSchema = new schema({
  _id: String,//use email to register user id
  nick_name: String,
  payment_method: [],
  age: Number,
  password: {
    salt: String,
    hashedPwd: String
  }
});
var userInfo = mongoose.model('userInfo' , userInfoSchema);


exports.addNewUser = function(jsonStr , res){
  var userinfo = JSON.parse(jsonStr);
  var plainPwd = userinfo.password;
  var salt = util.ramString(plainPwd.length);
  var pwdObj = new Object();
  var pwdPayload = salt + plainPwd;
  pwdObj.salt = salt;
  pwdObj.hashedPwd = md5(pwdPayload);
  userinfo.password = pwdObj;
  var newUser = new userInfo(userinfo);

  var rstObj = new Object();
  rstObj.result = constants.resStatus.SCUCCESS;
  newUser.save(function(err){
    if(!err){
      res.send(rstObj);
      return;
    }
    console.log('failed to add a new user ' + err.message);
    rstObj.result = constants.resStatus.FAILED;
    rstObj.erromsg = err.message;
    res.send(rstObj);
  });
}

exports.findUser = function(userID , res){
  userInfo.find({_id: userID} , function(err , res){
    if(!err){
      if(0 == rst.length || null == rst){
        rst = new Object();
        rst.result = constants.resStatus.NO_DATA;
        console.log('there\'s no data');
      }
      else{
        //rst = new Object();
        rst.result = constants.resStatus.SUCCESS;
        var data = new Object 

        for(var i = 0; i < rst.length; i++){
          data[i]._id = "N/A";
          data[i].password = new Object();
        }
      }
      rst.data = data;
      res.send(rst);
      return;
    }
    console.log(err.message);
    res.send({"result": constants.resStatus.FAILED, "error":message});
  });
}

exports.login = function(userID, userPwd , res){
  userInfo.find({"_id": userID} , function(err , rst){
    var judRst = new Object();
    if(!err){
      if(null == rst || 0 == rst.length){
        judRst.result = constants.resStatus.FAILED;
        judRst.message = 'The user doesn\'t exist';
      }
      else if (rst.length > 1) {
        judRst.result = constants.resStatus.FAILED;
        judRst.message = 'DB error, the DB contains 2 or more identical IDs';
      }
      else{
        var salt = rst[0].password.salt;
        var hashedPwd = rst[0].password.hashedPwd
        var newHashPwd = md5(salt + userPwd);
        if(hashedPwd == newHashPwd){
          judRst.result = constants.resStatus.VERIFIED;
        }
        else {
          judRst.result = constants.resStatus.FAILED;
        }
      }
    }
    res.send(judRst);
    return;
  });

}
