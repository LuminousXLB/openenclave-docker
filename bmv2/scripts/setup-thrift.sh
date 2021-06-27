#!/bin/bash

# Print commands and exit on errors
set -xe

THRIFT_VERSION=0.12.0

# Download thrift v0.12.0
wget https://github.com/apache/thrift/archive/refs/tags/v$THRIFT_VERSION.tar.gz -O thrift-$THRIFT_VERSION.tar.gz
tar xzf thrift-$THRIFT_VERSION.tar.gz

# Build thrift
pushd thrift-$THRIFT_VERSION
./bootstrap.sh
./configure --with-cpp=yes --with-c_glib=no --with-java=no --with-ruby=no --with-erlang=no --with-go=no --with-nodejs=no
make -j
sudo make install

pushd lib/py
sudo python3 setup.py install

popd
popd
