FROM ncl-sgx/openenclave:base-1.8

ARG MBEDTLS_VERSION=2.25.0

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    autossh \
    clang-format-10 \
    clang-tidy-10 \
    clang-tools-10 \
    clangd-10 \
    openssh-server \
    && rm -rf /var/lib/apt/lists/* \
    # link clang{-format, -tidy, d}-10
    && ln -s /usr/bin/clang-format-10 /usr/bin/clang-format \
    && ln -s /usr/bin/clang-tidy-10 /usr/bin/clang-tidy \
    && ln -s /usr/bin/clangd-10 /usr/bin/clangd \
    # install mbedtls
    && wget -nv https://github.com/ARMmbed/mbedtls/archive/refs/tags/v${MBEDTLS_VERSION}.tar.gz \
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

# CMD sudo service ssh start