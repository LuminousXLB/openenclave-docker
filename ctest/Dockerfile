FROM ncl-sgx/openenclave:base-1.8

ARG DEBIAN_FRONTEND=noninteractive

ARG UNAME=ubuntu
ARG GNAME=ubuntu
ARG UID=1000
ARG GID=1000

USER ${UID}

WORKDIR /home/${UNAME}

RUN git clone https://github.com/openenclave/openenclave.git \
    && cd openenclave \
    && git checkout ${OE_VERSION} \
    && git submodule init \
    && git submodule update \
    && mkdir build \
    && cd build \
    && cmake .. -GNinja -DENABLE_REFMAN=OFF \
    && ninja

WORKDIR /home/${UNAME}/openenclave/build

CMD ctest
