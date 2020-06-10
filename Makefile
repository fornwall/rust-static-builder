IMAGE=fredrikfornwall/rust-static-builder
STABLE_VERSION=1.44.0
CURRENT_DATE:=$(shell date "+%Y-%m-%d")

build-stable:
	docker build --build-arg TOOLCHAIN=$(STABLE_VERSION) -t $(IMAGE):$(STABLE_VERSION) .

push-stable: build-stable
	docker push $(IMAGE)

build-nightly:
	docker build --build-arg TOOLCHAIN=nightly -t $(IMAGE)-nightly:$(CURRENT_DATE) .

push-nightly: build-nightly
	docker push $(IMAGE)-nightly

clean:
	docker rmi $(IMAGE) $(IMAGE)-nightly

.PHONY: build-stable push-stable build-nightly push-nightly clean
