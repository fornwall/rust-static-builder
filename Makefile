IMAGE=fredrikfornwall/rust-static-builder
STABLE_VERSION=1.55.0
CURRENT_DATE:=$(shell date "+%Y-%m-%d")

build-stable:
	docker buildx build --platform linux/arm64/v8,linux/amd64 --build-arg TOOLCHAIN=$(STABLE_VERSION) --tag $(IMAGE):$(STABLE_VERSION) --tag $(IMAGE):latest .

push-stable: build-stable
	docker push --all-tags $(IMAGE)

build-nightly:
	docker buildx build --platform linux/arm64/v8,linux/amd64 --build-arg TOOLCHAIN=nightly --tag $(IMAGE)-nightly:$(CURRENT_DATE) --tag $(IMAGE)-nightly:latest .

push-nightly: build-nightly
	docker push --all-tags $(IMAGE)-nightly

clean:
	docker rmi $(IMAGE) $(IMAGE)-nightly

.PHONY: build-stable push-stable build-nightly push-nightly clean
