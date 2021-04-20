FROM rust:1.51 as builder

RUN USER=root cargo new --bin adi
WORKDIR ./adi
COPY ./Cargo.lock ./Cargo.toml ./
RUN cargo build --release
RUN rm src/*.rs
COPY ./src ./src
RUN rm ./target/release/deps/adi*
RUN cargo build --release

FROM ubuntu:20.04

RUN apt update && apt install -y libssl-dev

COPY --from=builder /adi/target/release/adi .
EXPOSE 8080
ENTRYPOINT ["./adi"]