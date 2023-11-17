#!/usr/bin/env bash

f_docker_push() {
  NEW_TAG=$1

  echo "--- $(date '+%H:%M:%S') Pushing Image: ${IMAGE_REPOSITORY}:${NEW_TAG}"
  docker tag "${IMAGE_REPOSITORY}:${IMAGE_TAG}" "${IMAGE_REPOSITORY}:${NEW_TAG}"
  docker push "${IMAGE_REPOSITORY}:${NEW_TAG}"
}

mkdir -p /go/bin
rm -rf /go/bin/*

set -e

echo "--- $(date '+%H:%M:%S') Downloading provider..."
buildkite-agent artifact download "/go/bin/terraform-provider-mysql" .

echo "--- $(date '+%H:%M:%S') Building Image: ${IMAGE_REPOSITORY}:${IMAGE_TAG}"
docker build -t "${IMAGE_REPOSITORY}:${IMAGE_TAG}" .

echo "--- $(date '+%H:%M:%S') Pushing Image: ${IMAGE_REPOSITORY}:${IMAGE_TAG}"
docker push ${IMAGE_REPOSITORY}:${IMAGE_TAG}


f_docker_push "latest"

if [ -z "$BUILDKITE_TAG" ] ; then

  # no tag, use branch & commit sha as image tag
  BRANCH="${BUILDKITE_BRANCH//\//_}"

  # this represents latest on the branch
  f_docker_push "${BRANCH}"

  # this tells which commit on the branch
  f_docker_push "${BRANCH}-${BUILDKITE_COMMIT:0:7}"

else

  # use git version tag as image tag
  f_docker_push "${BUILDKITE_TAG}"
fi