var configs = require('./configs');
var pubsub = require('redis').createClient(configs.redisPort, configs.redisHost);
console.log("anand create redis");
var events = new (require('events').EventEmitter)();
var Primus = require('primus');
var http = require('http');
var server = http.createServer(require('ecstatic')(__dirname + '/public'));
var primus = new Primus(server, { transformer: 'engine.io' });

primus.use('substream', require('substream'));

primus.on('connection', function (spark) {
  console.log("anand connection: ");

  var subscribeSpark = spark.substream('subscriptions');
  subscribeSpark.on('data', function (key) {
    console.log('SUB', key);
    var eventSpark = spark.substream(key);
    events.on('events:' + key, onEvent);
    spark.on('end', function () {
      console.log("anand UNSUB end: "+key);
      events.removeListener('events:' + key, onEvent);
      eventSpark.end();
    });
    function onEvent (data) {
      console.log("anand onEvent: "+data);
      eventSpark.write(data);
    }
  });
  spark.on('end', function () {
    console.log("anand end: ");
    subscribeSpark.end();
  });
});

pubsub.on('pmessage', function (pattern, channel, message) {
  console.log('EVENT', channel, message);
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