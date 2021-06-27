#!/bin/bash

# Print commands and exit on errors
set -xe

NANOMSG_VERSION=1.1.5

wget https://github.com/nanomsg/nanomsg/archive/refs/tags/$NANOMSG_VERSION.tar.gz -O nanomsg-$NANOMSG_VERSION.tar.gz
tar -xzvf nanomsg-$NANOMSG_VERSION.tar.gz

mkdir -p nanomsg-$NANOMSG_VERSION/build
pushd nanomsg-$NANOMSG_VERSION/build
# I added -DCMAKE_INSTALL_PREFIX=/usr because on my Ubuntu 14.04 machine, the
# library is installed in /usr/local/lib/x86_64-linux-gnu/ by default, and for
# some reason ldconfig cannot find it
cmake ..
# -DCMAKE_INSTALL_PREFIX=/usr
cmake --build .
sudo cmake --build . --target install
popd

sudo ldconfig

pip3 install nnpy
