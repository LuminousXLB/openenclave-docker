#!/bin/bash

# Print commands and exit on errors
set -xe

BMV2_VERSION=1.14.0

wget https://github.com/p4lang/behavioral-model/archive/refs/tags/$BMV2_VERSION.tar.gz -O behavioral-model-$BMV2_VERSION.tar.gz
tar xzf behavioral-model-$BMV2_VERSION.tar.gz

# https://github.com/p4lang/behavioral-model/tree/main/targets/simple_switch_grpc
pushd behavioral-model-$BMV2_VERSION
./autogen.sh
./configure --enable-debugger --with-pi
make -j
sudo make install
sudo ldconfig

pushd targets/simple_switch_grpc
./autogen.sh
./configure --with-thrift
make -j
sudo make install
sudo ldconfig
popd

popd
