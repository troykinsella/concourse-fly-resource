FROM alpine:edge
MAINTAINER Troy Kinsella <troy.kinsella@gmail.com>

COPY assets/* /opt/resource/

RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    jq \
    openssh \
    openssl \
 && update-ca-certificates
