FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive
ARG PCCS_SERVER

WORKDIR /root

RUN apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates git python3-apt linux-headers-$(uname -r) \
    && git clone --recursive https://github.com/openenclave/openenclave.git /root/openenclave \
    && cd /root/openenclave \
    && scripts/ansible/install-ansible.sh \
    && ansible-playbook scripts/ansible/oe-contributors-setup.yml \
    && scripts/ansible/remove-ansible.sh \
    && apt-get install --no-install-recommends -y libsgx-dcap-default-qpl \
    && rm -rf /var/lib/apt/lists/* \
    && test -z $(dpkg --list | grep az-dcap-client) \
    && ln -s $(readlink -f /usr/lib/x86_64-linux-gnu/libdcap_quoteprov.so.1) /usr/lib/x86_64-linux-gnu/libdcap_quoteprov.so \
    && sed "s/localhost:8081/"${PCCS_SERVER}"/g" -i /etc/sgx_default_qcnl.conf \
    && sed "s/USE_SECURE_CERT=TRUE/USE_SECURE_CERT=FALSE/g" -i /etc/sgx_default_qcnl.conf \
    && mkdir build \
    && cd build \
    && cmake .. -GNinja \
    && ninja \
    && ninja install

WORKDIR /root

CMD tail -f /dev/null