build:
	docker build -t fornwall/rust-static-builder .

push:
	docker push fornwall/rust-static-builder
