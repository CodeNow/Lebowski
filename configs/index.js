var processEnv = (typeof process != 'undefined') ? process.env.NODE_ENV : null;
var env = processEnv || 'production';
console.log('config env:', env);

if (env == "development") {
  module.exports = require("./development.json");
} else if (env == "dev") {
  module.exports = require("./dev.json");
  else if (env == "staging") {
  module.exports = require("./staging.json");
} else if (env == "integration") {
  module.exports = require("./integration.json");
} else if (env == "testing") {
  module.exports = require("./testing.json");
} else {
  module.exports = require("./production.json");
}
