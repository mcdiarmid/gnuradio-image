#!/bin/bash
set -x

GR_BRANCH=${1:-v3.10.10.0}

docker build \
    --build-arg="GR_BRANCH=$GR_BRANCH" \
    --build-arg USER="$USER" \
    --build-arg UID="$(id -u)" \
    --build-arg GID="$(id -g)" \
    --tag "my-gnuradio-image" \
    --file ./Dockerfile \
    .
