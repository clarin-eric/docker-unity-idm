include version

VERSION="1.8.1-SNAPSHOT"
FILE="unity-server-distribution-${VERSION}-dist.tar.gz"
OUTPUT_FILE="unity-server-distribution-${VERSION}-ldap-dist.tar.gz"

CWD="/Users/wilelb/Code/work/clarin/git/infrastructure/docker-unity-idm"

all: compile build

compile:
	cd /Users/wilelb/Code/work/eudat2020/unity-public; JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_31.jdk/Contents/Home M2_HOME=/usr/local/Cellar/maven/3.3.1/libexec /usr/local/Cellar/maven/3.3.1/libexec/bin/mvn -DskipTests=true clean install
	cd ${CWD}

copy:
#ifeq (,$(wildcard ./unity-server-distribution-1.8.1-SNAPSHOT-ldap-dist.tar.gz))
	@echo "Copying unity server distribution from local maven repository."
	@cp /Users/wilelb/.m2/repository/pl/edu/icm/unity/unity-server-distribution/${VERSION}/${FILE} ${OUTPUT_FILE}
#endif

build: copy
	@echo "Building docker image: ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}"
	@docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} . >> docker_build.log 2>&1

push:
	@docker push ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}

