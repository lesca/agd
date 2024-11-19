
# builder
FROM gradle:jdk17-alpine as builder
RUN apk add --update --no-cache curl vim git nodejs npm
ARG REPO_DIR
COPY ./${REPO_DIR} /app
WORKDIR /app

# compile 
RUN gradle jar -PskipHandbook=1 --no-daemon

# result image
FROM amazoncorretto:17-alpine

RUN apk add --update --no-cache curl vim git jq

WORKDIR /app
COPY --from=builder /app/keystore.p12 ./keystore.p12
COPY --from=builder /app/LunaGC-*.jar ./start.jar

# generate config.json
RUN java -jar /app/start.jar || true
RUN mv /app/config.json /app/config.json.bak

# entrypoint
COPY ./entrypoint.sh ./entrypoint.sh

ENTRYPOINT [ "sh", "/app/entrypoint.sh" ]

EXPOSE 11080 22102/udp