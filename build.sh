#!/bin/sh
set -e -u

cargo build --release --target x86_64-unknown-linux-musl

if [ -z ${NOSTRIP+x} ]; then
	strip -s `find target/x86_64-unknown-linux-musl/release/ -executable -type f -maxdepth 1`
else
	echo "Not stripping"
fi
