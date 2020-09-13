FROM golang:1.14-alpine AS build

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
        apk update && \
        apk add gcc linux-headers musl-dev git breezy && \
        wget https://github.com/hashicorp/nomad/archive/v0.12.4.tar.gz && \
        mkdir nomad && \
        tar -xzf *.tar.gz --strip-components=1 -C nomad/ && \
        cd nomad && \
        go build -o /bin/nomad \
        --ldflags '-linkmode external -extldflags "-static"' \
        -tags "nonvidia release ui" .

FROM alpine:3.12
VOLUME /var/persist/nomad
COPY --from=build /bin/nomad /bin/nomad
