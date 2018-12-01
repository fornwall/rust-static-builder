FROM ubuntu:18.10

RUN apt-get -qq update && \
    apt-get -qq install -y \
        build-essential \
        curl \
        musl-dev \
        musl-tools

ENV PATH=/root/.cargo/bin:/usr/local/musl/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- -y --default-toolchain stable && \
    rustup target add x86_64-unknown-linux-musl

COPY build.sh /root/build.sh

RUN mkdir /build
WORKDIR /build

#ENTRYPOINT ["cargo", "build", "--release", "--target", "x86_64-unknown-linux-musl" ]
ENTRYPOINT /root/build.sh

