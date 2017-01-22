var configs = require('./configs');
if (configs.newrelic) {
  require('newrelic');
}
var pubsub = require('redis').createClient(configs.redisPort, configs.redisHost);
var events = new (require('events').EventEmitter)();
var Primus = require('primus');
var http = require('http');
var server = http.createServer(require('ecstatic')(__dirname + '/public'));
var primus = new Primus(server, { transformer: 'engine.io' });

primus.use('substream', require('substream'));

primus.on('connection', function (spark) {
  var subscribeSpark = spark.substream('subscriptions');
  subscribeSpark.on('data', function (key) {
    console.log('SUB', key);
    var eventSpark = spark.substream(key);
    events.on('events:' + key, onEvent);
    spark.on('end', function () {
      events.removeListener('events:' + key, onEvent);
      eventSpark.end();
    });
    function onEvent (data) {
      eventSpark.write(data);
    }
  });
  spark.on('end', function () {
    subscribeSpark.end();
  });
});

pubsub.on('pmessage', function (pattern, channel, message) {
  console.log('EVENT', channel, message);
  events.emit(channel, message);
});

pubsub.psubscribe('events:*');

server.listen(configs.port);
