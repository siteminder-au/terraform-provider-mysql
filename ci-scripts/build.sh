#!/usr/bin/env bash

if [ -z "${BUILDKITE_TAG}" ] ; then

  APP_VERSION=${BUILDKITE_COMMIT:0:7}

else

  APP_VERSION=${BUILDKITE_TAG#v}

fi

echo "--- $(date '+%H:%M:%S') :docker: Fetching images..."
docker pull golang:1.12

set -e

echo "+++ $(date '+%H:%M:%S') :package: packaging provider..."
docker run \
  --name ${BUILDKITE_PIPELINE_SLUG}.$$ \
  -v ${PWD}:/app \
  -e BUILDKITE_TAG \
  -e APP_VERSION=$APP_VERSION \
  -e GOOS=$BINARY_OS \
  -e GOARCH=$BINARY_ARCH \
  -u root \
  -w /app \
  golang:1.12 \
  sh -c "apt-get update && apt-get -y upgrade && make build && mkdir -p bin && cp /go/bin/terraform-provider-mysql bin/"

echo "--- $(date '+%H:%M:%S') :docker: Cleanup..."
docker rm -vf ${BUILDKITE_PIPELINE_SLUG}.$$