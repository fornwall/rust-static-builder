# Rust static executable builder
Docker image for building statically linked Linux binaries from Rust projects.

## Building
From inside your project directoring containing a `Cargo.toml` file:

```sh
# Stable release channel:
docker run --rm -v "$PWD":/build fredrikfornwall/rust-static-builder

# Nightly release channel:
docker run --rm -v "$PWD":/build fredrikfornwall/rust-static-builder-nightly 
```

A statically linked executable will be created under `target/x86_64-unknown-linux-musl/release/`.

## Testing
Override the entry point to run tests against the statically linked executable:

```sh
docker run \
       -v "$(PWD)":/build \
       --entrypoint cargo \
       fredrikfornwall/rust-static-builder \
       test --target x86_64-unknown-linux-musl
```

## Disable stripping
By default the built executable will be stripped. Run with `-e NOSTRIP=1`, as in

```sh
docker run --rm -e NOSTRIP=1 -v "$(pwd)":/build fredrikfornwall/rust-static-builder
```

to disable stripping.

## Speeding up builds by sharing registry and git folders
To speed up builds the cargo registry and git folders can be mounted:

```sh
docker run \
       -v "$PWD":/build fredrikfornwall/rust-static-builder \
       -v $HOME/.cargo/git:/root/.cargo/git \
       -v $HOME/.cargo/registry:/root/.cargo/registry
```

## Creating a lightweight Docker image
The statically built executable can be used to create a lightweight Docker image built from scratch:

```dockerfile
FROM scratch
COPY target/x86_64-unknown-linux-musl/release/my-executable /
ENTRYPOINT ["/my-executable"]
```

## Native libraries and OpenSSL
The rust-static-builder image contains statically libraries for the following images in order for crates to be able to link them in:

- liblzma
- openssl
- zlib

Note that if the built executable needs certificates for OpenSSL [a base image containing /cacert.pem](scratch-with-certificates/Dockerfile) can be used:

```dockerfile
FROM fredrikfornwall/scratch-with-certificates
COPY target/x86_64-unknown-linux-musl/release/tls-using-executable /
ENTRYPOINT ["/tls-using-executable"]
```
