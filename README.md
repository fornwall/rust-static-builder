# Rust static executable builder
Docker image for building static Linux binaries from Rust projects.

## Building
From inside your project directoring containing a `Cargo.toml` file:

```sh
docker run --rm -v "$PWD":/build fredrikfornwall/rust-static-builder
```

This will create a statically linked output executable under

    target/x86_64-unknown-linux-musl/release/

## Disable stripping
By default the built executable will be stripped. Run with `-e NOSTRIP=1`, as in

```sh
docker run --rm -e NOSTRIP=1 -v "$(pwd)":/build fredrikfornwall/rust-static-builder
```

to disable stripping.

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

Note that if the built executable needs certificates for OpenSSL [a base image containing /cacert.pem](scratch-with-certificates/) can be used:

```dockerfile
FROM fredrikfornwall/scratch-with-certificates
COPY target/x86_64-unknown-linux-musl/release/tls-using-executable /
ENTRYPOINT ["/tls-using-executable"]
```

