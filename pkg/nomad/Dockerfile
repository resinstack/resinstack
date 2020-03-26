FROM golang:1.12-alpine AS build

RUN apk add gcc linux-headers musl-dev && \
        mkdir -p src/github.com/hashicorp && \
        mkdir -p /nomad/config /nomad/dynconfig && \
        cd src/github.com/hashicorp && \
        wget https://github.com/hashicorp/nomad/archive/v0.10.5.tar.gz && \
        mkdir nomad && \
        tar -xzf *.tar.gz --strip-components=1 -C nomad/ && \
        cd nomad && \
        go build -o /bin/nomad \
        --ldflags '-linkmode external -extldflags "-static"' \
        -tags "nonvidia release ui" .

FROM alpine:3.11
VOLUME /var/persist/nomad
COPY --from=build /bin/nomad /bin/nomad
