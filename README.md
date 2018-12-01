# Rust static builder
Docker image for building static Linux binaries from Rust cargo projects.

# Building
From inside your project directoring containing a `Cargo.toml` file:

```sh
docker run --rm -v "$(pwd)":/build fornwall/rust-static-builder
```

This will create a statically linked output executable under

    target/x86_64-unknown-linux-musl/release/
