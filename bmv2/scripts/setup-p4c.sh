#!/bin/bash

# Print commands and exit on errors
set -xe

git clone --recursive https://github.com/p4lang/p4c.git

cd p4c

mkdir build
cd build

cmake -DENABLE_EBPF=OFF -DENABLE_UBPF=OFF -DENABLE_DPDK=OFF -DENABLE_GTESTS=OFF -DENABLE_P4TEST=OFF ..
make -j
sudo make install
