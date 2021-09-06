#!/bin/bash
declare -r MODE_INTERACTIVE="interactive"
declare -r MODE_TEST="test"

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


mode="${MODE_TEST}"
while getopts ':i' opt; do
	case "${opt}" in
		i )
			mode="$MODE_INTERACTIVE"
			;;
		\? )
			echo "Invalid option: -${OPTARG}" 1>&2
			exit 1
			;;
	esac
done

case "${mode}" in
	"${MODE_INTERACTIVE}" )
		docker run --rm -ti -v "${dockerFileAbsPath}:/src" "dotfiles:latest" /src/scripts/docker_test.sh -i
		;;
	* )
		# Run the docker container
		docker run --rm -ti -v "${dockerFileAbsPath}:/src" "dotfiles:latest" /src/scripts/docker_test.sh -a
		;;
esac
