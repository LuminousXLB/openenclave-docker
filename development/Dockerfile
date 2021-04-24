FROM ncl-sgx/openenclave:base-1.8

ARG MBEDTLS_VERSION=2.25.0

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install --no-install-recommends -y \
    autossh \
    ccache \
    clang-format-10 \
    clang-tidy-10 \
    clang-tools-10 \
    clangd-10 \
    doxygen \
    expect \
    jq \
    kmod \
    libc++-8-dev \
    # libc++1 \
    libc++abi-8-dev \
    libuv1-dev \
    nodejs \
    openssh-server \
    python3.8-dev \
    python3.8-venv \
    shellcheck \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/clang-format-10 /usr/bin/clang-format \
    && ln -s /usr/bin/clang-tidy-10 /usr/bin/clang-tidy \
    && ln -s /usr/bin/clangd-10 /usr/bin/clangd \
    # install mbedtls
    && wget https://github.com/ARMmbed/mbedtls/archive/refs/tags/v${MBEDTLS_VERSION}.tar.gz \
    && tar -xf v${MBEDTLS_VERSION}.tar.gz \
    && mkdir -p mbedtls-${MBEDTLS_VERSION}/build \
    && cd mbedtls-${MBEDTLS_VERSION}/build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=ON .. \
    && make -j \
    && make install \
    && cd /tmp \
    && rm -rf *

ARG UNAME=ubuntu
ARG GNAME=ubuntu
ARG UID=1000
ARG GID=1000

USER ${UID}

WORKDIR /home/${UNAME}

ARG VEGETA_VERSION="12.8.4"

RUN wget https://github.com/tsenart/vegeta/releases/download/v${VEGETA_VERSION}/vegeta_${VEGETA_VERSION}_linux_amd64.tar.gz \
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
