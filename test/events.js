require('../server');

describe('events', function () {
  it('should receive events from redis', function (done) {
    var Primus = require('primus');
    var Socket = Primus.createSocket({
      plugin: {
        client: require('substream')
      }
    });
    var socket = new Socket('http://localhost:3480');
    socket.on('open', function () {
      socket.substream('events').on('data', function (data) {
        if (data === 'event') {
          done();
        }
      });
    });
    setTimeout(function () {
      var client = require('redis').createClient();
      client.publish('done', 'event');
    }, 10);
  });
});