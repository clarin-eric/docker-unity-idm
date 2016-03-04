include version

build:
	@docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} . >> docker_build.log 2>&1

push:
	@docker push ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}

all: build
