require('../server');

describe('events', function () {
  it('should receive events from redis after subscribing', function (done) {
    var Primus = require('primus');
    var Socket = Primus.createSocket({
      plugin: {
        client: require('substream')
      }
    });
    var socket = new Socket('http://localhost:3480');
    socket.on('open', function () {
      socket.substream('events').on('data', function (message) {
        if (message.key === 'done' && message.data === 'Fuck it, Dude, let\'s go bowling.') {
          done();
        } else {
          console.error(message);
        }
      });
      socket.substream('subscriptions').write('done');
      setTimeout(function () {
        var client = require('redis').createClient();
        client.publish('events:done', 'Fuck it, Dude, let\'s go bowling.');
      }, 10);
    });
  });
});