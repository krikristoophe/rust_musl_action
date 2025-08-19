test:
	touch /tmp/gh_out
	docker run --rm --platform=linux/amd64 \
        -v "$$PWD":/repo \
        -v "$$HOME/.cache/sccache":/github/home/.cache/sccache \
        -e GITHUB_OUTPUT=/tmp/gh_out \
        rust-musl-action:dev \
        stable x86_64-unknown-linux-musl "--release --locked" . true
