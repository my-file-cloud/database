FROM rust:1-slim AS builder

RUN apt-get update && apt-get install -y \
    musl-tools \
    && rm -rf /var/lib/apt/lists/*

RUN rustup target add x86_64-unknown-linux-musl

# rustls = pure-Rust TLS, required for musl (native-tls needs OpenSSL C libs)
RUN cargo install sqlx-cli \
    --no-default-features \
    --features mysql,rustls \
    --target x86_64-unknown-linux-musl

FROM alpine:3
COPY --from=builder /usr/local/cargo/bin/sqlx /usr/local/bin/sqlx
COPY migrations/ /migrations/

CMD ["sqlx", "migrate", "run", "--source", "/migrations"]
