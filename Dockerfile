FROM ubuntu:18.10

ARG TOOLCHAIN

RUN apt-get -qq update && \
    apt-get -qq upgrade && \
    apt-get -qq install -y \
        build-essential \
        curl \
        git \
        musl-dev \
        musl-tools \
        pkg-config

RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- -y --default-toolchain $TOOLCHAIN && \
    /root/.cargo/bin/rustup target add x86_64-unknown-linux-musl

RUN cd /tmp && LIBLZMA_VERSION=5.2.4 && \
    curl -LO "https://tukaani.org/xz/xz-$LIBLZMA_VERSION.tar.xz" && \
    tar xf "xz-$LIBLZMA_VERSION.tar.xz" && cd xz-$LIBLZMA_VERSION && \
    CC=musl-gcc ./configure --enable-static --disable-shared --prefix=/usr/local/musl && \
    make install

# -DOPENSSL_NO_SECURE_MEMORY needed due to https://github.com/openssl/openssl/issues/7207
RUN cd /tmp && OPENSSL_VERSION=1.1.1b && \
    curl -LO "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" && \
    tar xf "openssl-$OPENSSL_VERSION.tar.gz" && cd "openssl-$OPENSSL_VERSION" && \
    env CC=musl-gcc ./Configure \
        no-shared no-zlib no-engine no-unit-test -DOPENSSL_NO_SECURE_MEMORY \
        -fPIC --prefix=/usr/local/musl linux-x86_64 && \
    env C_INCLUDE_PATH=/usr/local/musl/include/ make depend && \
    make install_sw

RUN cd /tmp && ZLIB_VERSION=1.2.11 && \
    curl -LO "http://zlib.net/zlib-$ZLIB_VERSION.tar.gz" && \
    tar xf "zlib-$ZLIB_VERSION.tar.gz" && cd "zlib-$ZLIB_VERSION" && \
    CC=musl-gcc ./configure --static --prefix=/usr/local/musl && \
    make install

RUN cd /tmp && SQLITE_VERSION=sqlite-autoconf-3270200 && \
    curl -LO https://www.sqlite.org/2019/$SQLITE_VERSION.tar.gz && \
    tar xf "$SQLITE_VERSION.tar.gz" && cd "$SQLITE_VERSION" && \
    CC=musl-gcc ./configure --enable-static --disable-shared --prefix=/usr/local/musl && \
    make install

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
