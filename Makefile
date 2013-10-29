build:
	@ ./node_modules/.bin/browserify ./lib/client.js -o ./public/bundle.js 
install:
	@npm install

.PHONY: install
.PHONY: build