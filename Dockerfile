FROM docker:stable

ARG compose_version=1.22.0
ENV RANCHER_COMPOSE_VERSION=v0.12.5
ENV RANCHER_CLI_VERSION=v0.6.11

# Install docker-compose (extra complicated since the base image uses alpine as base)
RUN apk update && apk add --no-cache \
    curl openssl ca-certificates \
    && curl -L https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk \
    && apk add --no-cache glibc-2.28-r0.apk && rm glibc-2.28-r0.apk \
    && ln -s /lib/libz.so.1 /usr/glibc-compat/lib/ \
    && ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib

RUN apk upgrade --update && \
    apk add --update ca-certificates curl tar xz && \
    curl -jksSL -o /tmp/rc.tar.gz https://github.com/rancher/rancher-compose/releases/download/${RANCHER_COMPOSE_VERSION}/rancher-compose-linux-amd64-${RANCHER_COMPOSE_VERSION}.tar.gz && \
    tar -xzf /tmp/rc.tar.gz -C /usr/local/bin --strip-components=2 && \
    rm /tmp/rc.tar.gz && \
    chmod +x /usr/local/bin/rancher-compose && \
    apk del curl

RUN apk upgrade --update && \
    apk add --update ca-certificates curl tar xz && \
    curl -jksSL -o /tmp/rcli.tar.gz https://github.com/rancher/cli/releases/download/${RANCHER_CLI_VERSION}/rancher-linux-amd64-${RANCHER_CLI_VERSION}.tar.gz && \
    tar -xzf /tmp/rcli.tar.gz -C /usr/local/bin --strip-components=2 && \
    rm /tmp/rcli.tar.gz && \
    chmod +x /usr/local/bin/rancher && \
    apk del curl

