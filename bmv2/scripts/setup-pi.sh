#!/bin/bash

# Print commands and exit on errors
set -xe

git clone --recursive https://github.com/p4lang/PI.git

sudo ldconfig

# https://github.com/p4lang/behavioral-model/tree/main/targets/simple_switch_grpc
cd PI
./autogen.sh
./configure --with-proto
make -j
sudo make install
