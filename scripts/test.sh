#!/bin/bash

dockerFileRelPath="$(dirname $0)/../"
dockerFileAbsPath="$(cd "${dockerFileRelPath}"; pwd)"

# Check if docker image already exists, if not crate it
imageName=$(docker images --format "{{.Repository}}:{{.Tag}}"|grep "dotfiles:latest")
if [ -z "${imageName}" ]; then
    echo "Have to create the image"
    docker build -t "dotfiles:latest" "${dockerFileAbsPath}"
else
    echo "The image exists"
fi

# Run the docker container
docker run --rm -ti -v "${dockerFileAbsPath}:/src" "dotfiles:latest" /src/scripts/docker_test.sh
