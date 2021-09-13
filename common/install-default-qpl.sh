#!/bin/sh

set -xe

apt-get install --no-install-recommends -y libsgx-dcap-default-qpl

QCNL_CONF=/etc/sgx_default_qcnl.conf

if [ $PCCS_SERVER ]; then
    sed "s/localhost:8081/"$PCCS_SERVER"/g" -i $QCNL_CONF
fi

sed "s/USE_SECURE_CERT=TRUE/USE_SECURE_CERT=FALSE/g" -i $QCNL_CONF

cat $QCNL_CONF
