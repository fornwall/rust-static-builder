build:
	docker build -t fredrikfornwall/rust-static-builder .

push: build
	docker push fredrikfornwall/rust-static-builder

.PHONY: build push
