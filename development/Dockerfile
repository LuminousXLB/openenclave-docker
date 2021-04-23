FROM ncl-sgx/openenclave:base-1.8

ARG DEBIAN_FRONTEND=noninteractive

ARG UNAME=ubuntu
ARG GNAME=ubuntu
ARG UID=1000
ARG GID=1000


RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    clangd-10 \
    clang-format-10 \
    clang-tidy-10 \
    openssh-server \
    autossh \
    libmbedtls-dev \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/clang-format-10 /usr/bin/clang-format \
    && ln -s /usr/bin/clang-tidy-10 /usr/bin/clang-tidy \
    && ln -s /usr/bin/clangd-10 /usr/bin/clangd

USER ${UID}

WORKDIR /home/${UNAME}

RUN cp -r /opt/openenclave/share/openenclave/samples openenclave-samples \
    && git clone https://github.com/microsoft/CCF.git --recursive


CMD tail -f /dev/null
