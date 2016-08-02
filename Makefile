include version

all: build

copy:
ifeq (,$(wildcard ./unity-server-distribution-1.8.1-SNAPSHOT-ldap-dist.tar.gz))
	@echo "Copying unity server distribution from local maven repository."
	@cp /Users/wilelb/Code/work/eudat2020/unity-public/distribution/target/unity-server-distribution-1.8.1-SNAPSHOT-dist.tar.gz ~/Downloads/unity-server-distribution-1.8.1-SNAPSHOT-ldap-dist.tar.gz .
endif

build: copy
	@echo "Building docker image: ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}"
	@docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} . >> docker_build.log 2>&1

push:
	@docker push ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}


