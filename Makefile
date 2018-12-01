build:
	docker build -t fredrikfornwall/rust-static-builder .

push:
	docker push fredrikfornwall/rust-static-builder
