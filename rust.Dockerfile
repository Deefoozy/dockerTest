FROM rust:1.63.0 as build

COPY code ./

RUN cargo build --release


FROM rust:1.63.0-slim as runtime

COPY --from=build ./target/release/test_project ./

EXPOSE 80
ENTRYPOINT ./test_project
