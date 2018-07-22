FROM alpine:edge
LABEL MAINTAINER="Troy Kinsella <troy.kinsella@gmail.com>"

COPY assets/* /opt/resource/

RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    jq ;\
    update-ca-certificates
