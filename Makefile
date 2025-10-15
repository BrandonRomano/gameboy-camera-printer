setup-env:
	$(MAKE) -C src/esc-pos-image

watch: setup-env
	source .env && ./src/watch.sh
