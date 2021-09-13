#!/bin/sh

set -xe

apt-get update

apt-get install --no-install-recommends -y \
    gnupg \
    ca-certificates

. /etc/os-release

apt-key adv --fetch-keys https://apt.llvm.org/llvm-snapshot.gpg.key
echo "deb http://apt.llvm.org/${VERSION_CODENAME}/ llvm-toolchain-${VERSION_CODENAME}-10 main" | tee /etc/apt/sources.list.d/llvm-toolchain-$VERSION_CODENAME-10.list

apt-key adv --fetch-keys https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key
echo "deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu ${VERSION_CODENAME} main" | tee /etc/apt/sources.list.d/intel-sgx.list

apt-key adv --fetch-keys https://packages.microsoft.com/keys/microsoft.asc
echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/${VERSION_ID}/prod ${VERSION_CODENAME} main" | tee /etc/apt/sources.list.d/msprod.list

apt-get update
