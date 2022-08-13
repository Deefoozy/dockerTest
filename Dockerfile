FROM rust:1.63.0-alpine as build

WORKDIR /code

COPY code ./

RUN apk add build-base
RUN cargo build --target x86_64-unknown-linux-musl

RUN chmod +x ./target/release/test_project


FROM alpine as runtime

COPY --from=build ./code/target/release ./code

EXPOSE 69

ENTRYPOINT ls -a -l ./code && ./code/test_project
