var processEnv = (typeof process != 'undefined') ? process.env.NODE_ENV : null;
var env = processEnv || 'production';
console.log('config env:', env);

module.exports = require("./default.json");
