ARG BASE

FROM ${BASE}

ARG OE_VERSION

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
    && git submodule update --init --recursive \
    && mkdir build \
    && cd build \
    && cmake .. -GNinja -DENABLE_REFMAN=OFF \
    && ninja

WORKDIR /home/${UNAME}/openenclave/build

CMD ctest
