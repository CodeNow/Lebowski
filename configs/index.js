var processEnv = (typeof process != 'undefined') ? process.env.NODE_ENV : null;
var env = processEnv || 'production';
console.log('config env:', env);

if (env == "development") {
  module.exports = require("./development.json");
} else if (env == "integration") {
  module.exports = require("./integration.json");
} else if (env == "testing") {
  module.exports = require("./testing.json");
} else if (env == "replica"){
  module.exports = require("./replica.json");
}else {
	module.exports = require("./production.json");
}
