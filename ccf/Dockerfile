FROM ncl-sgx/openenclave:dev-1.8

ARG DEBIAN_FRONTEND=noninteractive

USER 0

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install --no-install-recommends -y \
    ccache \
    doxygen \
    expect \
    jq \
    kmod \
    libc++-8-dev \
    libc++abi-8-dev \
    libuv1-dev \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

ARG UNAME=ubuntu
ARG GNAME=ubuntu
ARG UID=1000
ARG GID=1000

USER ${UID}

WORKDIR /home/${UNAME}

ARG VEGETA_VERSION="12.8.4"

RUN wget -nv https://github.com/tsenart/vegeta/releases/download/v${VEGETA_VERSION}/vegeta_${VEGETA_VERSION}_linux_amd64.tar.gz \
    && sudo mkdir -p /opt/vegeta \
    && sudo tar -xf vegeta_${VEGETA_VERSION}_linux_amd64.tar.gz -C /opt/vegeta \
    && rm vegeta_${VEGETA_VERSION}_linux_amd64.tar.gz \
    && cp -r /opt/openenclave/share/openenclave/samples openenclave-samples \
    && git clone https://github.com/microsoft/CCF.git --recursive \
    && cd CCF \
    && mkdir build \
    && cd build \
    && cmake -GNinja .. \
    && ninja


CMD tail -f /dev/null
