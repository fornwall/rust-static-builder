IMAGE=fredrikfornwall/scratch-with-certificates

build:
	docker build -t $(IMAGE) .

push: build
	docker push $(IMAGE)

download:
	curl -O https://curl.se/ca/cacert.pem

.PHONY: build download push
