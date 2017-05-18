FROM alpine:edge
MAINTAINER Malte Schirmacher <malte.schirmacher@etecture.de>

COPY assets/* /opt/resource/

RUN apk add --no-cache \
    ca-certificates \
    curl \
    jq \
    openssh \
    openssl \
 && update-ca-certificates
