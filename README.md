[![Build status](https://github.com/fornwall/rust-static-builder/workflows/Build/badge.svg)](https://github.com/fornwall/rust-static-builder/actions?query=branch%3Amaster)
[![Docker Hub](https://img.shields.io/docker/v/fredrikfornwall/rust-static-builder.svg?label=docker)](https://hub.docker.com/r/fredrikfornwall/rust-static-builder)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

# Rust static binary builder
Docker image for building statically linked Linux binaries from Rust projects.

## Building
From inside your project directoring containing a `Cargo.toml` file:

```sh
# Stable release channel:
docker run -v "$PWD":/build fredrikfornwall/rust-static-builder:1.60.0

# Nightly release channel:
docker run -v "$PWD":/build fredrikfornwall/rust-static-builder-nightly:2022-04-09
```

A statically linked binary will be created under `target/x86_64-unknown-linux-musl/release/`.

## Speeding up builds by sharing registry and git folders
To speed up builds the cargo registry and git folders can be mounted:

```sh
docker run \
       -v "$PWD":/build \
       -v $HOME/.cargo/git:/root/.cargo/git \
       -v $HOME/.cargo/registry:/root/.cargo/registry \
       fredrikfornwall/rust-static-builder:1.60.0
```

## Testing
Override the entry point to run tests against the statically linked binary:

```sh
docker run \
       -v "$PWD":/build \
       -v $HOME/.cargo/git:/root/.cargo/git \
       -v $HOME/.cargo/registry:/root/.cargo/registry \
       --entrypoint cargo \
       fredrikfornwall/rust-static-builder:1.60.0 \
       test --target x86_64-unknown-linux-musl
```

## Disable stripping
By default the built binary will be stripped. Run with `-e NOSTRIP=1`, as in

```sh
docker run \
       -e NOSTRIP=1 \
       -v "$PWD":/build \
       fredrikfornwall/rust-static-builder:1.60.0
```

to disable stripping.

## Creating a lightweight Docker image
The built binary can be used to create a lightweight Docker image built from scratch:

```dockerfile
FROM scratch
COPY target/x86_64-unknown-linux-musl/release/my-executable /
ENTRYPOINT ["/my-executable"]
```

## Native libraries and OpenSSL
The rust-static-builder image contains statically libraries for the following images in order for crates to be able to link them in:

- [bzip2](https://www.sourceware.org/bzip2/)
- [liblzma](https://tukaani.org/xz/)
- [openssl](https://www.openssl.org/)
- [sqlite](https://www.sqlite.org/)
- [zlib](https://zlib.net/)

Note that if the projects needs certificates for OpenSSL a [base image containing /cacert.pem](scratch-with-certificates/Dockerfile) can be used when building a Docker image:

```dockerfile
FROM fredrikfornwall/scratch-with-certificates
COPY target/x86_64-unknown-linux-musl/release/tls-using-executable /
ENTRYPOINT ["/tls-using-executable"]
```
