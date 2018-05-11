FROM docker:17.03.0

ARG compose_version=1.18.0
ENV RANCHER_COMPOSE_VERSION=v0.10.0

# Install docker-compose (extra complicated since the base image uses alpine as base)
RUN apk update && apk add --no-cache \
    curl openssl ca-certificates \
    && curl -L https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk \
    && apk add --no-cache glibc-2.23-r3.apk && rm glibc-2.23-r3.apk \
    && ln -s /lib/libz.so.1 /usr/glibc-compat/lib/ \
    && ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib

RUN apk upgrade --update && \
    apk add --update ca-certificates curl tar xz && \
    curl -jksSL -o /tmp/rc.tar.gz https://github.com/rancher/rancher-compose/releases/download/${RANCHER_COMPOSE_VERSION}/rancher-compose-linux-amd64-${RANCHER_COMPOSE_VERSION}.tar.gz && \
    tar -xzf /tmp/rc.tar.gz -C /usr/local/bin --strip-components=2 && \
    rm /tmp/rc.tar.gz && \
    chmod +x /usr/local/bin/rancher-compose && \
    apk del curl