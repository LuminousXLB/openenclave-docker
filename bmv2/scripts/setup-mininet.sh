#!/bin/bash

# Print commands and exit on errors
set -xe

git clone -b 2.3.0 https://github.com/mininet/mininet.git

./mininet/util/install.sh -nv
# ./mininet/util/install.sh -nwv
