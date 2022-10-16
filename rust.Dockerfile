# syntax = docker/dockerfile:1.2
# use buildkit for this dockerfile, this allows us to use cache mounts & much more
# see the dockerfile reference: https://docs.docker.com/engine/reference/builder/

# Separate fetching dependencies & compiling. So that these individual steps can be cached by docker
FROM rust:1.63.0 as fetch

RUN cargo init /rust-build/
WORKDIR /rust-build/

# NOTE: The COPY command determines if a step has to be rerun(!). 
# If any of the files in a COPY command have changed then it will execute the entire build of a stage again.
# Try to be as specific as possible when copying in files
COPY code/Cargo.toml ./
COPY code/Cargo.lock ./
RUN CARGO_HOME=.cargo-home/ cargo fetch

FROM fetch as build

# Default "Build profile". This allows switching to 'dev', 'release', 'test', 'bench' or a custom profile specified in Cargo.toml
ARG build_profile=release
# Name of the binary to build
ARG compile_target
# Name of the folders the binaries are located in
ARG build_folder

WORKDIR /rust-build/

# Include just the source files, those are the only files that should trigger a rebuild
COPY code/src ./src/

# Run cargo in offline mode so we don't download anything. 
# We already downloaded the dependencies in the 'fetch' step
# the '--mount type=cache' flag causes the entire target directory to be cached. Speeding up rebuilds considerably
RUN --mount=type=cache,sharing=private,target=./target \
    CARGO_HOME=.cargo-home/ cargo build --offline --profile ${build_profile} --bin ${compile_target} && cp ./target/${build_folder}/${compile_target} ./


FROM rust:1.63.0-slim as runtime
ARG compile_target

RUN adduser rust-runner
USER rust-runner
RUN mkdir ~/rust-application/

WORKDIR /home/rust-runner/rust-application/

COPY --from=build --chown=rust-runner:rust-runner /rust-build/${compile_target} /home/rust-runner/rust-application/rust-app

RUN whoami && ls -la ~/rust-application/ && cd ~/rust-application/ && echo ${compile_target} && sleep 11s

EXPOSE 3096
ENTRYPOINT /home/rust-runner/rust-application/rust-app
