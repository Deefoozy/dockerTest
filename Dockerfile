FROM rust:1.63.0-alpine as build

WORKDIR /home/tino/Desktop/testCases/DockerCompose/code

COPY code ./

RUN apk add build-base
RUN cargo build --target x86_64-unknown-linux-musl

EXPOSE 69


FROM alpine as runtime

COPY --from=build ./home/tino/Desktop/testCases/DockerCompose/code/target/release ./code

RUN chmod 777 ./code
RUN chmod +x ./code/test_project

ENTRYPOINT ls -a -l ./code && ./code/test_project
