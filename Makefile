IMAGE=fredrikfornwall/rust-static-builder

build:
	docker build --build-arg TOOLCHAIN=stable -t $(IMAGE) .
	docker build --build-arg TOOLCHAIN=nightly -t $(IMAGE)-nightly .

clean:
	docker rmi $(IMAGE) $(IMAGE)-nightly

push: build
	docker push $(IMAGE)
	docker push $(IMAGE)-nightly

.PHONY: build clean push
