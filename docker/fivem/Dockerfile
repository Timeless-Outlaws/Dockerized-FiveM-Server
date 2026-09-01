ARG FIVEM_NUM=35713
ARG FIVEM_VER=03dcc562ca175e24eb018569ecb919b4b7a56824
ARG DATA_VER=32d98e7524b952faf8b220d719615b0346b0a6cc

FROM spritsail/alpine:3.14 as builder

ARG FIVEM_NUM
ARG FIVEM_VER
ARG DATA_VER

WORKDIR /output

RUN wget -O- http://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/${FIVEM_NUM}-${FIVEM_VER}/fx.tar.xz \
        | tar xJ --strip-components=1 \
            --exclude alpine/dev --exclude alpine/proc \
            --exclude alpine/run --exclude alpine/sys \
 && mkdir -p /output/opt/cfx-server-data /output/usr/local/share \
 && wget -O- http://github.com/citizenfx/cfx-server-data/archive/${DATA_VER}.tar.gz \
        | tar xz --strip-components=1 -C opt/cfx-server-data \
    \
 && apk -p $PWD add tini mysql-client

ADD server.cfg opt/cfx-server-data
ADD entrypoint usr/bin/entrypoint
ADD wait-for-mysql usr/bin/wait-for-mysql

RUN chmod +x /output/usr/bin/entrypoint
RUN chmod +x /output/usr/bin/wait-for-mysql

#================

FROM scratch

ARG FIVEM_VER
ARG FIVEM_NUM
ARG DATA_VER

LABEL maintainer="Timeless Outlaws <privat@skyraptor.eu>" \
      org.label-schema.vendor="Timeless Outlaws" \
      org.label-schema.name="Dockerized FiveM Server" \
      org.label-schema.url="https://fivem.net" \
      org.label-schema.description="FiveM is a modification for Grand Theft Auto V enabling you to play multiplayer on customized dedicated servers." \
      org.label-schema.version=${FIVEM_NUM} \
      io.spritsail.version.fivem=${FIVEM_NUM}-${FIVEM_VER} \
      io.spritsail.version.fivem_data=${DATA_VER}

COPY --from=builder /output/ /

WORKDIR /config
EXPOSE 30120

# Default to an empty CMD, so we can use it to add seperate args to the binary
CMD [""]

ENTRYPOINT ["/bin/sh", "-c", "/usr/bin/wait-for-mysql && /sbin/tini -- /usr/bin/entrypoint"]

# Check if the server is alive
HEALTHCHECK CMD curl --fail http://127.0.0.1:30120/info.json || exit 1
