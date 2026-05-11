# Stage 1: install sqlx-cli
FROM rust:1-slim AS builder

RUN apt-get update && apt-get install -y pkg-config libssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN cargo install sqlx-cli --no-default-features --features mysql,native-tls

# Stage 2: minimal runtime image
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y ca-certificates libssl3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/cargo/bin/sqlx /usr/local/bin/sqlx
COPY migrations/ /migrations/

RUN useradd -r -s /bin/false appuser
USER appuser

CMD ["sqlx", "migrate", "run", "--source", "/migrations"]
