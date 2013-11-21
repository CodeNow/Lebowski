var configs = require('./configs');
var pubsub = require('redis').createClient(configs.redisPort, configs.redisHost);
var events = new (require('events').EventEmitter)();
var Primus = require('primus');
var http = require('http');
var server = http.createServer(require('ecstatic')(__dirname + '/public'));
var primus = new Primus(server);

primus.use('substream', require('substream'));

primus.on('connection', function (spark) {
  var subscribeSpark = spark.substream('subscriptions');
  subscribeSpark.on('data', function (key) {
    var eventSpark = spark.substream(key);
    events.on('events:' + key, function (data) {
      eventSpark.write(data);
    });
  });
});

pubsub.on('pmessage', function (pattern, channel, message) {
  events.emit(channel, message);
});

pubsub.psubscribe('events:*');

server.listen(configs.port);


// anounce frontend
var client = require('redis').createClient(configs.redisPort, configs.redisHost);
var front = 'frontend:cybertron.' + configs.domain;
client.multi()
  .del(front)
  .rpush(front, 'The Dude')
  .rpush(front, 'http://' + configs.host + ':' + configs.port)
  .exec(function (err) {
    if (err) {
      throw err;
    }
    client.quit();
  });