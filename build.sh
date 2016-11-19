#!/bin/bash

set -e

DOCKER_IMAGE_NAME="swarm-prune"
DOCKER_CONTAINER_NAME="swarm-prune-build-container"

if [[ $(docker ps -a | grep $DOCKER_CONTAINER_NAME) != "" ]]; then
    echo "remove $DOCKER_CONTAINER_NAME"
    docker rm -f $DOCKER_CONTAINER_NAME
fi

docker build --pull -t $DOCKER_IMAGE_NAME -f Dockerfile.build .

docker run --name $DOCKER_CONTAINER_NAME $DOCKER_IMAGE_NAME

mkdir -p bin
docker cp $DOCKER_CONTAINER_NAME:/go/bin/swarm-prune bin/swarm-prune

if [[ $(docker ps -a | grep $DOCKER_CONTAINER_NAME) != "" ]]; then
    echo "remove $DOCKER_CONTAINER_NAME"
    docker rm -f $DOCKER_CONTAINER_NAME
fi
