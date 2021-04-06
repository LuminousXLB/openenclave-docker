FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive
ARG DCAP=DCAP_1.10

WORKDIR /root

RUN apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates curl g++ git make openssl python zip \
    && curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install --no-install-recommends -y nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/intel/SGXDataCenterAttestationPrimitives.git \
    && cd SGXDataCenterAttestationPrimitives \
    && git checkout ${DCAP} \
    && cd tools/PCKCertSelection \
    && make -j -C PCKCertSelectionLib \
    && cd ../../../ \
    && mv SGXDataCenterAttestationPrimitives/QuoteGeneration/pccs ./ \
    && mkdir -p pccs/lib \
    && mv SGXDataCenterAttestationPrimitives/tools/PCKCertSelection/out/libPCKCertSelection.so ./pccs/lib/ \
    && rm -rf SGXDataCenterAttestationPrimitives

WORKDIR /root/pccs

ARG CONFIG_FILE=./config/default.json

ARG HTTPS_PORT=8081
ARG HOST=0.0.0.0
ARG API_KEY
ARG ADMIN_TOKEN
ARG USER_TOKEN

RUN test -n "${API_KEY}" \
    && test -n "${ADMIN_TOKEN}" \
    && test -n "${USER_TOKEN}" \
    && npm install \
    && npm config set engine-strict true \
    && npm ci \
    && npm cache clean --force \
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
