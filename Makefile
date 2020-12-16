IMAGE=fredrikfornwall/rust-static-builder
STABLE_VERSION=1.48.0
CURRENT_DATE:=$(shell date "+%Y-%m-%d")

build-and-push-stable:
	docker buildx build --platform linux/amd64,linux/arm64 --build-arg TOOLCHAIN=$(STABLE_VERSION) --tag $(IMAGE):$(STABLE_VERSION) --push .

build-and-push-nightly:
	docker buildx build --platform linux/amd64,linux/arm64 --build-arg TOOLCHAIN=nightly --tag $(IMAGE)-nightly:$(CURRENT_DATE) --push .

.PHONY: build-and-push-stable build-and-push-nightly
