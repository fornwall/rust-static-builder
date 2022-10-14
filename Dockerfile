FROM ubuntu:22.04

ARG TOOLCHAIN

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install -y \
        build-essential \
        curl \
        git \
        musl-dev \
        musl-tools \
        pkg-config && \
    ln -s /usr/include/x86_64-linux-gnu/asm /usr/include/x86_64-linux-musl/asm

RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- -y --default-toolchain $TOOLCHAIN && \
    /root/.cargo/bin/rustup target add x86_64-unknown-linux-musl

RUN cd /tmp && LIBLZMA_VERSION=5.2.7 && \
    curl -LO "https://tukaani.org/xz/xz-$LIBLZMA_VERSION.tar.xz" && \
    tar xf "xz-$LIBLZMA_VERSION.tar.xz" && cd xz-$LIBLZMA_VERSION && \
    CC=musl-gcc ./configure --enable-static --disable-shared --prefix=/usr/local/musl && \
    make install

# See https://github.com/openssl/openssl/issues/7207 for "-idirafter" CC setting
RUN cd /tmp && OPENSSL_VERSION=3.0.5 && \
    curl -LO "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" && \
    tar xf "openssl-$OPENSSL_VERSION.tar.gz" && cd "openssl-$OPENSSL_VERSION" && \
    env CC="musl-gcc -static -idirafter /usr/include/ -idirafter /usr/include/x86_64-linux-gnu/" ./Configure \
        no-shared no-zlib no-engine no-unit-test \
        -fPIC --prefix=/usr/local/musl linux-x86_64 && \
    env C_INCLUDE_PATH=/usr/local/musl/include/ make depend && \
    make install_sw

RUN cd /tmp && ZLIB_VERSION=1.2.13 && \
    curl -LO "https://zlib.net/zlib-$ZLIB_VERSION.tar.gz" && \
    tar xf "zlib-$ZLIB_VERSION.tar.gz" && cd "zlib-$ZLIB_VERSION" && \
    CC=musl-gcc ./configure --static --prefix=/usr/local/musl && \
    make install

RUN cd /tmp && SQLITE_VERSION=sqlite-autoconf-3390400 && \
    curl -LO https://www.sqlite.org/2022/$SQLITE_VERSION.tar.gz && \
    tar xf "$SQLITE_VERSION.tar.gz" && cd "$SQLITE_VERSION" && \
    CC=musl-gcc ./configure --enable-static --disable-shared --prefix=/usr/local/musl && \
    make install

RUN cd /tmp && BZ2_VERSION=1.0.8 && \
    curl -LO ftp://sourceware.org/pub/bzip2/bzip2-$BZ2_VERSION.tar.gz && \
    tar xf "bzip2-$BZ2_VERSION.tar.gz" && cd "bzip2-$BZ2_VERSION" && \
    make CC=musl-gcc PREFIX=/usr/local/musl bzip2 && \
    make install PREFIX=/usr/local/musl

RUN rm -r /tmp/*

ENV \
    LIBZ_SYS_STATIC=1 \
    OPENSSL_DIR=/usr/local/musl/ \
    OPENSSL_INCLUDE_DIR=/usr/local/musl/include/ \
    OPENSSL_LIB_DIR=/usr/local/musl/lib/ \
    OPENSSL_STATIC=1 \
    PATH=/root/.cargo/bin:/usr/bin:/bin \
    PKG_CONFIG_ALLOW_CROSS=true \
    PKG_CONFIG_ALL_STATIC=true \
    PKG_CONFIG_LIBDIR=/usr/local/musl/lib/pkgconfig/ \
    TARGET=musl

RUN mkdir /build
WORKDIR /build

COPY build.sh /root/build.sh
ENTRYPOINT /root/build.sh
