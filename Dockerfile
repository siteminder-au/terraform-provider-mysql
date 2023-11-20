FROM golang:1.12 AS builder

ARG GOOS
ARG GOARCH

COPY [".", "/app"]

WORKDIR /app

RUN apt-get update && apt-get -y upgrade && make build

FROM alpine AS production

RUN mkdir -p /provider

COPY --from=builder ["/go/bin/terraform-provider-mysql", "/provider/terraform-provider-mysql"]

WORKDIR /provider
