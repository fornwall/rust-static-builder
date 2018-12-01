# Rust static builder
Docker image for building static Linux binaries from Rust projects.

## Building
From inside your project directoring containing a `Cargo.toml` file:

```sh
docker run --rm -v "$(pwd)":/build fredrikfornwall/rust-static-builder
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
