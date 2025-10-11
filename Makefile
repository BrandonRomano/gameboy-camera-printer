setup-env:
	$(MAKE) -C src/esc-pos-image

print-test: setup-env
	./src/gbp.sh

watch: setup-env
	source .env && ./src/watch.sh
