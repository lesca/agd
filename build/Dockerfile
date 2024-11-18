FROM rust:alpine as builder
RUN apk add --no-cache musl-dev

COPY ./sakura-rs /app

WORKDIR /app

RUN cargo build --release --bin sakura-sdk-server
RUN cargo build --release --bin sakura-dispatch-server
RUN cargo build --release --bin sakura-gate-server
RUN cargo build --release --bin sakura-game-server

# result image
FROM alpine:latest
RUN apk add --no-cache vim busybox-extras

WORKDIR /app

COPY --from=builder /app/target/release/sakura-sdk-server /app/sakura-sdk-server
COPY --from=builder /app/target/release/sakura-dispatch-server /app/sakura-dispatch-server
COPY --from=builder /app/target/release/sakura-gate-server /app/sakura-gate-server
COPY --from=builder /app/target/release/sakura-game-server /app/sakura-game-server

COPY ./sakura-rs/assets /app/assets
COPY ./entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["sh", "/app/entrypoint.sh"]

EXPOSE 21000 21041 22101/udp
