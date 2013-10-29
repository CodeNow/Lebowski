var primus = new Primus();

primus.substream('events').on('data', console.log.bind(console));
primus.substream('subscriptions').write('done');