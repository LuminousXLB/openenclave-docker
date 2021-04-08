FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive
ARG PCCS_SERVER

WORKDIR /root

RUN apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates git python3-apt linux-headers-$(uname -r) \
    && git clone --recursive https://github.com/openenclave/openenclave.git /root/openenclave \
    && cd /root/openenclave \
    && git checkout ${OE_VERSION} \
    && scripts/ansible/install-ansible.sh \
    && ansible-playbook scripts/ansible/oe-contributors-setup.yml \
    && scripts/ansible/remove-ansible.sh \
    # && apt-get install --no-install-recommends -y libsgx-dcap-default-qpl \
    && curl https://download.01.org/intel-sgx/sgx-dcap/1.10/linux/distro/ubuntu18.04-server/debian_pkgs/libs/libsgx-dcap-default-qpl/libsgx-dcap-default-qpl_1.8.100.2-bionic1_amd64.deb --output libsgx-dcap-default-qpl.deb \
    && dpkg -i ./libsgx-dcap-default-qpl.deb \
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

WORKDIR /root/openenclave/build

CMD tail -f /dev/null
