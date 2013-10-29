var primus = new Primus();

primus.substream('events').on('data', console.log.bind(console));