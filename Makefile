IMAGE=fredrikfornwall/rust-static-builder
STABLE_VERSION=1.41.0
CURRENT_DATE:=$(shell date "+%Y-%m-%d")

build:
	docker build --build-arg TOOLCHAIN=$(STABLE_VERSION) -t $(IMAGE):$(STABLE_VERSION) .
	docker build --build-arg TOOLCHAIN=nightly -t $(IMAGE)-nightly:$(CURRENT_DATE) .

clean:
	docker rmi $(IMAGE) $(IMAGE)-nightly

push: build
	docker push $(IMAGE)
	docker push $(IMAGE)-nightly

.PHONY: build clean push
