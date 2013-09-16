require('coffee-script');
global._ = require('underscore');
global.localEnvironment = 'development';
module.exports = require('./app/server-app');
