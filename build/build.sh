# Environment variables
export HTTPS_PROXY=http://192.168.2.8:8080
export HTTP_PROXY=http://192.168.2.8:8080
export NO_PROXY=localhost,127.0.0.1,172.16.0.0/12,10.0.0.0/8,192.168.0.0/16

# pull the images
if [ ! "$(docker images -q rust:alpine 2> /dev/null)" ]; then
  docker pull rust:alpine
fi
if [ ! "$(docker images -q postgres:latest 2> /dev/null)" ]; then
  docker pull postgres:latest
fi
if [ ! "$(docker images -q redis:latest 2> /dev/null)" ]; then
  docker pull redis:latest
fi

# Image parameters
IMAGE_AUTHOR=lesca
IMAGE_NAME=agd
IMAGE_TAG=xeon-5.0.0

# remove the image if it exists
docker rmi ${IMAGE_AUTHOR}/${IMAGE_NAME}:${IMAGE_TAG}

# determine the dockerfile to use
if [ -d "release" ]; then
    DOCKER_FILE=Dockerfile-release
else
    PROJECT_NAME=XilonenImpact
    DOCKER_FILE=Dockerfile
    if [ ! -d "${PROJECT_NAME}" ]; then
        git clone https://git.xeondev.com/reversedrooms/${PROJECT_NAME}.git
        cd ${PROJECT_NAME}
        git checkout 92c687cae2 # 5.0.0
        cd ..
    fi
fi


# build the image
echo "Building ${IMAGE_AUTHOR}/${IMAGE_NAME}:${IMAGE_TAG} using ${DOCKER_FILE}"
docker build -f $DOCKER_FILE \
--build-arg HTTP_PROXY=${HTTP_PROXY} \
--build-arg HTTPS_PROXY=${HTTPS_PROXY} \
--build-arg NO_PROXY=${NO_PROXY} \
-t ${IMAGE_AUTHOR}/${IMAGE_NAME}:${IMAGE_TAG} .
