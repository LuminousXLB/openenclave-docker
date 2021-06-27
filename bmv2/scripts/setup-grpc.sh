#!/bin/bash

# Print commands and exit on errors
set -xe

GRPC_VERSION=1.38.0

git clone --recursive -b v$GRPC_VERSION https://github.com/google/grpc.git grpc-$GRPC_VERSION

pushd grpc-$GRPC_VERSION

mkdir -p third_party/abseil-cpp/cmake/build
pushd third_party/abseil-cpp/cmake/build
cmake -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE \
    ../..
make -j
sudo make install
popd

pushd third_party/protobuf/
export CFLAGS="-Os"
export CXXFLAGS="-Os"
export LDFLAGS="-Wl,-s"
./autogen.sh
./configure --prefix=/usr
make -j
sudo make install
sudo ldconfig
unset CFLAGS CXXFLAGS LDFLAGS
popd

mkdir -p cmake/build
pushd cmake/build
cmake -DgRPC_INSTALL=ON \
    -DgRPC_BUILD_TESTS=OFF \
    ../..
make -j
sudo make install
popd

pip install protobuf grpcio
