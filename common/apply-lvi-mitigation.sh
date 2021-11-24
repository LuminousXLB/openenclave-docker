#!/bin/sh

set -xe

. /etc/os-release
OE_PREFIX=/opt/openenclave
OE_LVI_BIN_DIR=/opt/oe_lvi
OE_LVI_SCRIPTS_DIR=${OE_PREFIX}/bin/scripts/lvi-mitigation
TMP=/tmp/oe-lvi-tmp

mkdir -p ${OE_LVI_BIN_DIR}
cp ${OE_LVI_SCRIPTS_DIR}/invoke_compiler ${OE_LVI_BIN_DIR}/invoke_compiler
chmod 0555 ${OE_LVI_BIN_DIR}/invoke_compiler

ln -s $(which clang-10) ${OE_LVI_BIN_DIR}/clang-10_symlink
${OE_LVI_SCRIPTS_DIR}/generate_wrapper --name=clang-10 --path=${OE_LVI_BIN_DIR}

ln -s $(which clang++-10) ${OE_LVI_BIN_DIR}/clang++-10_symlink
${OE_LVI_SCRIPTS_DIR}/generate_wrapper --name=clang++-10 --path=${OE_LVI_BIN_DIR}

ln -s $(which gcc) ${OE_LVI_BIN_DIR}/gcc_symlink
${OE_LVI_SCRIPTS_DIR}/generate_wrapper --name=gcc --path=${OE_LVI_BIN_DIR}

ln -s $(which g++) ${OE_LVI_BIN_DIR}/g++_symlink
${OE_LVI_SCRIPTS_DIR}/generate_wrapper --name=g++ --path=${OE_LVI_BIN_DIR}

mkdir -p ${TMP}
wget -qO- https://download.01.org/intel-sgx/latest/linux-latest/as.ld.objdump.r4.tar.gz | tar xz -C ${TMP}
cp ${TMP}/external/toolset/${ID}${VERSION_ID}/* ${OE_LVI_BIN_DIR}
rm -rf ${TMP}
