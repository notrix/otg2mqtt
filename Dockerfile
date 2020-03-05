ARG BUILD_FROM=hassioaddons/base:7.0.2

FROM ${BUILD_FROM}

ENV LANG C.UTF-8

COPY rootfs /

WORKDIR /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
    apk add --no-cache --virtual .build-dependencies \
        g++=9.2.0-r3 \
        gcc=9.2.0-r3 \
        libc-dev=0.7.2-r0 \
        linux-headers=4.19.36-r0 \
        make=4.2.1-r2 \
        py2-pip=18.1-r0 \
        python2-dev=2.7.16-r3

RUN apk add --no-cache \
        nodejs \
        npm

RUN npm config set unsafe-perm true

RUN npm install \
        --no-audit \
        --no-optional \
        --no-update-notifier \
        --only=production \
        --unsafe-perm

RUN npm cache clear --force

# RUN echo -e "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

RUN apk del --no-cache --purge .build-dependencies

RUN rm -fr /tmp/*

ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="otg2mqtt" \
    io.hass.description="Publish OpenThermGateway events to MQTT queues" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Vaidas Lažauskas <vaidas@notrix.lt>" \
    org.label-schema.description="Publish OpenThermGateway events to MQTT queues" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="otg2mqtt" \
    org.label-schema.schema-version="1.0"

RUN chmod a+x /execute.sh

CMD [ "/execute.sh" ]
