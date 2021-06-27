ARG BASE

FROM ${BASE}
# FROM ncl-sgx/openenclave:dev-1.10

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp

COPY scripts scripts

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    autoconf \
    automake \
    bison \
    flex \
    graphviz \
    libboost-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-iostreams-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-test-dev \
    libboost-thread-dev \
    libevent-dev \
    libfl-dev \
    libgc-dev \
    libgmp-dev \
    libjudy-dev \
    libpcap-dev \
    llvm \
    python-all-dev \
    python-pip \
    python-setuptools \
    python-wheel \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    tcpdump \
    && pip --no-cache-dir install \
    scapy \
    setuptools \
    ply \
    psutil \
    && chmod +x ./scripts/*.sh \
    && ./scripts/setup-mininet.sh \
    && ./scripts/setup-thrift.sh \
    && ./scripts/setup-nanomsg.sh \
    && ./scripts/setup-grpc.sh \
    && ./scripts/setup-pi.sh \
    && ./scripts/setup-bmv2.sh \
    && ./scripts/setup-p4c.sh \
    && rm -rf /var/lib/apt/lists/*

ARG UNAME=ubuntu
ARG GNAME=ubuntu
ARG UID=1000
ARG GID=1000

USER ${UID}

WORKDIR /home/${UNAME}

RUN git clone https://github.com/p4lang/tutorials.git

CMD sudo service ssh start && autossh -N -R 56789:localhost:22 ubuntu@aws.taraxacum.ink
