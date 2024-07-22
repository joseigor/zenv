#!/bin/sh

set -eu

. ./project_config.sh

BUILD_DOCKERFILE=${BUILD_DOCKERFILE:-.}
BUILD_IMAGE_NAME=${BUILD_IMAGE_NAME:-$PROJECT_NAME}
BUILD_CONTAINER_NAME=${BUILD_CONTAINER_NAME:-$PROJECT_NAME"-builder-container"}

usage()
{
	echo "Usage: ${0} [OPTIONS]"
	echo "Build docker images and creates docker conainters."
	echo "Available options:"
	echo "    -a   Build docker image and container for BUILD purpouse."
	echo "    -b   Run build container."
	echo "    -r   Remove all images and containers."
}

cleanup() {
	trap EXIT
}

create_builder_container() {

	echo "info" "Will create builder container and run in detached mode."

	docker build --build-arg WORKDIR_PATH="${PROJECT_NAME}" -t "${BUILD_IMAGE_NAME}" -f "${BUILD_DOCKERFILE}" .


	if [ "$(docker ps -a -q -f name="${BUILD_CONTAINER_NAME}")" ]; then
		docker rm -f "${BUILD_CONTAINER_NAME}" > /dev/null
	fi

	docker \
		run \
		-it \
		-v $(pwd):/${PROJECT_NAME} \
		--name "${BUILD_CONTAINER_NAME}" \
		-d "${BUILD_IMAGE_NAME}"

	echo "info" "Builder container running in detached mode"

}

run_builder_container() {

	echo "info" "Will run builder docker container."

	# checks if container exists
	if [ ! "$(docker ps -a -q -f name="${BUILD_CONTAINER_NAME}")" ]; then
		create_builder_container
	fi

	# checks if container is running
	if [ ! "$(docker ps -q -f status=running -f name="${BUILD_CONTAINER_NAME}")" ]; then
		docker start "${BUILD_CONTAINER_NAME}" > /dev/null
	fi

	docker exec -it "${BUILD_CONTAINER_NAME}" /bin/sh

	echo "info" "Exited from builder docker container."

}


docker_clean_all() {
echo "info" "Will remove all docker containers and images."

	# remove builder
	if [ "$(docker ps -q -f status=running -f name="${BUILD_CONTAINER_NAME}")" ]; then
		echo "Stoping container "${BUILD_CONTAINER_NAME}"."
		docker stop "${BUILD_CONTAINER_NAME}" > /dev/null
		echo "Container ${BUILD_CONTAINER_NAME} stoped."
	fi

	if [ "$(docker ps -a -q -f name="${BUILD_CONTAINER_NAME}")" ]; then
		echo "Removing container "${BUILD_CONTAINER_NAME}"."
		docker rm "${BUILD_CONTAINER_NAME}" > /dev/null
		echo "Container "${BUILD_CONTAINER_NAME}" removed."
	fi


	# remove builder image
	# Order is important if images have dependency
	if [ "$(docker images -q "${BUILD_IMAGE_NAME}")" ]; then
		echo "Removing image "${BUILD_IMAGE_NAME}"."
		docker rmi "${BUILD_IMAGE_NAME}" > /dev/null
		echo "Image ${BUILD_IMAGE_NAME} removed."
	fi


	echo "info" "All  docker containers and images removed."
}

main()
{
	while getopts ":habr" _options; do
		case "${_options}" in
		h)
			usage
			exit 0
			;;
		a)
			create_builder_container
			;;
		b)
			run_builder_container
			;;


		r)
			docker_clean_all
			;;

		:)
			echo "Option -${OPTARG} requires an argument."
			exit 1
			;;
		?)
			echo "Invalid option: -${OPTARG}"
			exit 1
			;;
		esac
	done

	cleanup
}

main "${@}"

exit 0

