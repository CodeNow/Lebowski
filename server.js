var pubsub = require('redis').createClient();
var events = new (require('events').EventEmitter)();
var Primus = require('primus');
var http = require('http');
var server = http.createServer(require('ecstatic')(__dirname + '/public'));
var primus = new Primus(server);

primus.use('substream', require('substream'));

primus.on('connection', function (spark) {
  var eventSpark = spark.substream('events');
  events.on('done', function (data) {
    eventSpark.write(data);
  });
});

pubsub.on('pmessage', function (pattern, channel, message) {
  events.emit(channel, message);
});

pubsub.psubscribe('*');

server.listen(3480);
