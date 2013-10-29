build:
	@ ./node_modules/.bin/browserify ./client.js -o ./public/bundle.js 
install:
	@npm install

.PHONY: install
.PHONY: build