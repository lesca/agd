FROM rust:alpine as builder
RUN apk add --no-cache musl-dev

COPY ./XilonenImpact /app

WORKDIR /app

RUN cargo build --release --bin sdkserver
RUN cargo build --release --bin dispatch
RUN cargo build --release --bin dbgate
RUN cargo build --release --bin gateserver
RUN cargo build --release --bin gameserver

# result image
FROM alpine:latest
RUN apk add --no-cache vim busybox-extras postgresql-client

WORKDIR /app

COPY --from=builder /app/target/release/sdkserver /app/sdkserver
COPY --from=builder /app/target/release/dispatch /app/dispatch
COPY --from=builder /app/target/release/dbgate /app/dbgate
COPY --from=builder /app/target/release/gateserver /app/gateserver
COPY --from=builder /app/target/release/gameserver /app/gameserver

COPY ./XilonenImpact/data /app/data
COPY ./entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["sh", "/app/entrypoint.sh"]

EXPOSE 21000 21041 22101/udp
