ARG BASE

FROM ${BASE}

ARG DEBIAN_FRONTEND=noninteractive

ARG UNAME=ubuntu
ARG GNAME=ubuntu
ARG UID=1000
ARG GID=1000



RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    autoconf \
    automake \
    debhelper \
    libcurl4-openssl-dev \
    libprotobuf-dev \
    libsgx-epid \
    libsgx-dcap-default-qpl-dev \
    libsgx-dcap-ql-dev \
    libsgx-enclave-common-dev \
    ocaml \
    ocamlbuild \
    perl \
    protobuf-compiler \
    python-is-python3 \
    reprepro \
    unzip \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/intel \
    && useradd --create-home --shell /bin/bash jeremy \
    && usermod -a -G sgx_prv jeremy

# install intel sgx sdk
WORKDIR /opt/intel

RUN wget https://download.01.org/intel-sgx/latest/linux-latest/distro/ubuntu20.04-server/sgx_linux_x64_sdk_2.14.100.2.bin \
    && chmod +x sgx_linux_x64_sdk_2.14.100.2.bin \
    && echo 'yes' | ./sgx_linux_x64_sdk_2.14.100.2.bin \
    && rm ./sgx_linux_x64_sdk_2.14.100.2.bin

USER ${UID}

WORKDIR /home/${UNAME}

RUN echo "source /opt/intel/sgxsdk/environment" >> .bashrc

CMD sudo service ssh start && autossh -N -R 42530:localhost:22 ubuntu@aws.taraxacum.ink
