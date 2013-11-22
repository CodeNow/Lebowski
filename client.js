var primus = new Primus({ transformer: 'engine.io' });

primus.substream('done').on('data', console.log.bind(console, 'done:'));
primus.substream('subscriptions').write('done');

primus.substream('progress').on('data', console.log.bind(console, 'progress:'));
primus.substream('subscriptions').write('progress');