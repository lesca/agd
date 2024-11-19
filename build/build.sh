# image params
VERSION="5.0.0"
IMAGE_AUTHOR="lesca"
IMAGE_NAME="agd"
IMAGE_TAG="lunagc-${VERSION}"

# Environment variables
export HTTPS_PROXY=http://192.168.2.8:8080
export HTTP_PROXY=http://192.168.2.8:8080
export NO_PROXY=localhost,127.0.0.1,172.16.0.0/12,10.0.0.0/8,192.168.0.0/16

echo "Building ${IMAGE_AUTHOR}/${IMAGE_NAME}:${IMAGE_TAG}"

# fetch the repository
# if LunaGC_${VERSION} not exists, clone the repository
if [ ! -d "LunaGC_${VERSION}" ]; then
    git clone --branch main https://github.com/Kei-Luna/LunaGC_${VERSION}.git
fi

# remove the image if it exists
docker rmi ${IMAGE_AUTHOR}/${IMAGE_NAME}:${IMAGE_TAG}

# build the image
echo "Building ${IMAGE_AUTHOR}/${IMAGE_NAME}:${IMAGE_TAG}"
docker build --build-arg REPO_DIR=LunaGC_${VERSION} \
--build-arg HTTP_PROXY=${HTTP_PROXY} \
--build-arg HTTPS_PROXY=${HTTPS_PROXY} \
--build-arg NO_PROXY=${NO_PROXY} \
-t ${IMAGE_AUTHOR}/${IMAGE_NAME}:${IMAGE_TAG} .
