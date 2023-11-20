FROM alpine

RUN mkdir -p /provider

WORKDIR /provider

COPY ["bin/terraform-provider-mysql", "terraform-provider-mysql"]