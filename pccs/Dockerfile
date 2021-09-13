FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive
ARG DCAP_VERSION

WORKDIR /root

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
    ca-certificates \
    curl \
    g++ \
    git \
    make \
    openssl \
    python \
    && curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install --no-install-recommends -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# https://github.com/openenclave/openenclave/issues/4139
# https://github.com/intel/SGXDataCenterAttestationPrimitives/pull/190
COPY crl-format.patch .

RUN set -x \
    && git clone https://github.com/intel/SGXDataCenterAttestationPrimitives.git \
    && cd SGXDataCenterAttestationPrimitives \
    && git checkout ${DCAP_VERSION} \
    # fix crl format
    && git apply --reject --whitespace=fix /root/crl-format.patch \
    && cd tools/PCKCertSelection \
    && make -j -C PCKCertSelectionLib \
    && cd ../../../ \
    && mv SGXDataCenterAttestationPrimitives/QuoteGeneration/pccs ./ \
    && mkdir -p pccs/lib \
    && mv SGXDataCenterAttestationPrimitives/tools/PCKCertSelection/out/libPCKCertSelection.so ./pccs/lib/ \
    && rm -rf SGXDataCenterAttestationPrimitives \
    && cd /root/pccs \
    && npm install \
    && npm config set engine-strict true \
    && npm ci \
    && npm cache clean --force

WORKDIR /root/pccs

ARG CONFIG_TEMPLATE=./config/default.json
ARG CONFIG_FILE=./config/default.json

ARG HTTPS_PORT=8081
ARG HOST=0.0.0.0
ARG API_KEY
ARG ADMIN_TOKEN
ARG USER_TOKEN

RUN set -x \
    && test -n "${API_KEY}" \
    && test -n "${ADMIN_TOKEN}" \
    && test -n "${USER_TOKEN}" \
    && (test ${CONFIG_TEMPLATE} = ${CONFIG_FILE} || cp ${CONFIG_TEMPLATE} ${CONFIG_FILE}) \
    && sed "/\"HTTPS_PORT\"*/c\ \ \ \ \"HTTPS_PORT\" \: ${HTTPS_PORT}," -i ${CONFIG_FILE} \
    && sed "/\"hosts\"*/c\ \ \ \ \"hosts\" \: \"${HOST}\"," -i ${CONFIG_FILE} \
    && sed "/\"ApiKey\"*/c\ \ \ \ \"ApiKey\" \: \"${API_KEY}\"," -i ${CONFIG_FILE} \
    && sed "/\"AdminTokenHash\"*/c\ \ \ \ \"AdminTokenHash\" \: \"$(echo -n "${ADMIN_TOKEN}" | sha512sum | tr -d '[:space:]-')\"," -i ${CONFIG_FILE} \
    && sed "/\"UserTokenHash\"*/c\ \ \ \ \"UserTokenHash\" \: \"$(echo -n "${USER_TOKEN}" | sha512sum | tr -d '[:space:]-')\"," -i ${CONFIG_FILE} \
    && mkdir ssl_key \
    && openssl genrsa -out ssl_key/private.pem 2048 \
    && openssl req -new -key ssl_key/private.pem -out ssl_key/csr.pem -subj "/CN=pccs.internal/" \
    && openssl x509 -req -days 365 -in ssl_key/csr.pem -signkey ssl_key/private.pem -out ssl_key/file.crt \
    && openssl x509 -in ssl_key/file.crt -noout -text

CMD npm start
