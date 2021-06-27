ARG BASE

FROM ${BASE}

ARG MBEDTLS_VERSION

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    autossh \
    bsdmainutils  \
    clang-format-10 \
    clang-tidy-10 \
    netcat \
    openssh-server \
    python3-dev \
    unzip \
    vim \
    zip \
    && pip3 --no-cache-dir install \
    cmakelang \
    setuptools \
    wheel \
    && rm -rf /var/lib/apt/lists/* \
    # link clang{-format, -tidy, d}-10
    && ln -s /usr/bin/clang-8 /usr/bin/clang \
    && ln -s /usr/bin/clang++-8 /usr/bin/clang++ \
    && ln -s /usr/bin/clang-format-10 /usr/bin/clang-format \
    && ln -s /usr/bin/clang-tidy-10 /usr/bin/clang-tidy \
    # install mbedtls
    && wget -nv https://github.com/ARMmbed/mbedtls/archive/refs/tags/v${MBEDTLS_VERSION}.tar.gz \
    && tar -xf v${MBEDTLS_VERSION}.tar.gz \
    && mkdir -p mbedtls-${MBEDTLS_VERSION}/build \
    && cd mbedtls-${MBEDTLS_VERSION}/build \
    && CC=clang cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DENABLE_TESTING=Off .. \
    && make -j \
    && make install \
    && cd /tmp \
    && rm -rf *
