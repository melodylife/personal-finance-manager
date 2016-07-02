#!/usr/bin/nodejs

var express = require('express');
var path = require('path');
//var favicon = require('static-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var mongoose = require('mongoose');

var routes = require('./routes/index');
var tblOperations = require('./routes/tblOps');
var appinit = require('./routes/appinit');
var healthcheckhandler = require('./routes/healthcheck');

//homebrew middleware
var jsonParser = require('./util/middleware/jsonParser');

var app = express();

//Confiuration
var conf = require('./conf/serConf.json');

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

//app.use(favicon());
app.use(logger('dev'));
//app.use(bodyParser.urlencoded());
app.use(jsonParser.base64ReqBodyParser);
app.use(bodyParser.raw());
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', routes);
app.use('/appinit', appinit);
app.use('/tblOps' , tblOperations);
app.use('/healthcheck' , healthcheckhandler);

/// catch 404 and forwarding to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

/// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});


console.log('started@' + conf.port);

app.listen(conf.port);

module.exports = app;
