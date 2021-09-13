#!/bin/sh

set -xe

if [ -z $MBEDTLS_VERSION ]; then
    echo "z"
    MBEDTLS_VERSION=2.27.0
fi

wget -qO- https://github.com/ARMmbed/mbedtls/archive/refs/tags/v${MBEDTLS_VERSION}.tar.gz | tar xz -C /tmp

WORKDIR=/tmp/mbedtls-$MBEDTLS_VERSION
CC=clang

mkdir -p $WORKDIR/build
cd mbedtls-${MBEDTLS_VERSION}/build
cmake -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DENABLE_TESTING=OFF \
    ..
make -j
make install

rm -rf $WORKDIR