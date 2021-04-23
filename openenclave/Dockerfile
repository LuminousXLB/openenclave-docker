FROM ubuntu:bionic

ARG CURRENT_DISTR=ubuntu18.04
ARG OE_VERSION=v0.15.0
ARG PCCS_SERVER

ARG DEBIAN_FRONTEND=noninteractive

ARG UNAME=ubuntu
ARG GNAME=ubuntu
ARG UID=1000
ARG GID=1000

ARG LOCAL_LVI_DIRECTORY=/usr/local/lvi-mitigation

WORKDIR /root

# Remove dkms ?
# RUN curl https://download.01.org/intel-sgx/latest/dcap-latest/linux/distro/${CURRENT_DISTR}-server/sgx_linux_x64_driver_1.41.bin -o sgx_linux_x64_driver.bin \
#     && chmod +x sgx_linux_x64_driver.bin \
#     && ./sgx_linux_x64_driver.bin

RUN  apt-get update \
    && apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates \
    gnupg \
    software-properties-common \
    sudo \
    && groupadd --gid ${GID} ${GNAME} \
    && groupadd --gid 1001 sgx_prv \
    && useradd --create-home --uid ${UID} --gid ${GID} --shell /bin/bash ${UNAME} \
    && usermod -a -G sgx_prv ${UNAME} \
    && echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    # add apt repositories
    && apt-key adv --fetch-keys https://apt.llvm.org/llvm-snapshot.gpg.key \
    && apt-key adv --fetch-keys https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key \
    && apt-key adv --fetch-keys https://packages.microsoft.com/keys/microsoft.asc \
    && echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-7 main" | tee /etc/apt/sources.list.d/llvm-toolchain-bionic-7.list \
    && echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-10 main" | tee /etc/apt/sources.list.d/llvm-toolchain-bionic-10.list \
    && echo 'deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu bionic main' | tee /etc/apt/sources.list.d/intel-sgx.list \
    && echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/18.04/prod bionic main" | tee /etc/apt/sources.list.d/msprod.list \
    && apt-get update \
    # intall dependencies
    && apt-get install --no-install-recommends -y \
    build-essential \
    clang-10 \
    clang-8 \
    curl \
    # dkms \
    gdb \
    git\
    libprotobuf10 \
    libssl-dev \
    libtool\
    linux-headers-$(uname -r) \
    ninja-build \
    openssl \
    pkg-config\
    python \
    python3-apt \
    python3-pip \
    wget \
    && pip3 --no-cache-dir install cmake \
    # install sgx psw
    && apt-get install --no-install-recommends -y \
    libsgx-ae-pce \
    libsgx-ae-qe3 \
    libsgx-ae-qve \
    libsgx-aesm-ecdsa-plugin \
    libsgx-aesm-pce-plugin \
    libsgx-aesm-quote-ex-plugin \
    libsgx-dcap-ql \
    libsgx-dcap-ql-dev \
    libsgx-enclave-common \
    libsgx-pce-logic \
    libsgx-qe3-logic \
    libsgx-quote-ex \
    libsgx-urts \
    sgx-aesm-service \
    # libsgx-dcap-default-qpl_1.8
    # && apt-get install --no-install-recommends -y libsgx-dcap-default-qpl \
    && curl https://download.01.org/intel-sgx/sgx-dcap/1.10/linux/distro/ubuntu18.04-server/debian_pkgs/libs/libsgx-dcap-default-qpl/libsgx-dcap-default-qpl_1.8.100.2-bionic1_amd64.deb -o libsgx-dcap-default-qpl.deb \
    && dpkg -i ./libsgx-dcap-default-qpl.deb \
    && test -z $(dpkg --list | grep az-dcap-client) \
    && ln -s $(readlink -f /usr/lib/x86_64-linux-gnu/libdcap_quoteprov.so.1) /usr/lib/x86_64-linux-gnu/libdcap_quoteprov.so \
    # clone openenclave repository
    && git clone https://github.com/openenclave/openenclave.git /root/openenclave \
    && cd /root/openenclave \
    && git checkout ${OE_VERSION} \
    && git submodule init \
    && git submodule update \
    && cd /root \
    # apply lvi-mitigation
    && curl https://download.01.org/intel-sgx/latest/linux-latest/as.ld.objdump.gold.r3.tar.gz -o as.ld.objdump.gold.r3.tar.gz \
    && tar -xf as.ld.objdump.gold.r3.tar.gz \
    && mkdir -p ${LOCAL_LVI_DIRECTORY}/bin \
    && cp /root/external/toolset/${CURRENT_DISTR}/* ${LOCAL_LVI_DIRECTORY}/bin \
    && cp /root/openenclave/scripts/lvi-mitigation/* ${LOCAL_LVI_DIRECTORY}/bin \
    && ${LOCAL_LVI_DIRECTORY}/bin/generate_wrapper --name=clang-8 --path=${LOCAL_LVI_DIRECTORY}/bin \
    && ${LOCAL_LVI_DIRECTORY}/bin/generate_wrapper --name=clang++-8 --path=${LOCAL_LVI_DIRECTORY}/bin \
    && ${LOCAL_LVI_DIRECTORY}/bin/generate_wrapper --name=gcc --path=${LOCAL_LVI_DIRECTORY}/bin \
    && ${LOCAL_LVI_DIRECTORY}/bin/generate_wrapper --name=g++ --path=${LOCAL_LVI_DIRECTORY}/bin \
    && ln -s $(which clang-8) ${LOCAL_LVI_DIRECTORY}/bin/clang-8_symlink \
    && ln -s $(which clang++-8) ${LOCAL_LVI_DIRECTORY}/bin/clang++-8_symlink \
    && ln -s $(which gcc) ${LOCAL_LVI_DIRECTORY}/bin/gcc_symlink \
    && ln -s $(which g++) ${LOCAL_LVI_DIRECTORY}/bin/g++_symlink \
    && sed "s/localhost:8081/"${PCCS_SERVER}"/g" -i /etc/sgx_default_qcnl.conf \
    && sed "s/USE_SECURE_CERT=TRUE/USE_SECURE_CERT=FALSE/g" -i /etc/sgx_default_qcnl.conf \
    && cd /root/openenclave \
    && mkdir build \
    && cd build \
    && cmake .. -GNinja -DENABLE_REFMAN=OFF \
    && ninja \
    && ninja install \
    && cd /root \
    # clean up
    && rm -rf \
    /var/lib/apt/lists/* \
    as.ld.objdump.gold.r3.tar.gz \
    libsgx-dcap-default-qpl.deb \
    /root/external \
    /root/openenclave

CMD tail -f /dev/null
