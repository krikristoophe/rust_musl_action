build-test-image:
	docker build --platform=linux/amd64 -t rust-musl-action:dev .
