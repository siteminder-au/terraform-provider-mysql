FROM golang:0.12

RUN mkdir -p /provider

WORKDIR /provider

COPY ["bin/terraform-provider-mysql", "terraform-provider-mysql"]