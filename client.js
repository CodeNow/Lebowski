var primus = new Primus();

primus.substream('done').on('data', console.log.bind(console));
primus.substream('subscriptions').write('done');