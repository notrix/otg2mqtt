ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

COPY rootfs /

WORKDIR /

RUN apk add nodejs npm

RUN npm config set unsafe-perm true

RUN npm install --no-audit --no-optional --no-update-notifier --only=production --unsafe-perm

RUN chmod a+x /execute.sh

CMD [ "/execute.sh" ]
