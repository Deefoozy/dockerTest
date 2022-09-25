# Separate fetching dependencies & compiling. So that these individual steps can be cached by docker
FROM rust:1.63.0 as fetch

RUN cargo init /rust-build/
WORKDIR /rust-build/

# NOTE: The COPY command determines if a step has to be rerun(!). 
# If any of the files in a COPY command have changed then it will execute the entire build again.
# Try to be as specific as possible when copying in files
COPY code/Cargo.toml ./
COPY code/Cargo.lock ./
RUN CARGO_HOME=.cargo-home/ cargo fetch

FROM fetch as build

WORKDIR /rust-build/

# Include just the source files, those are the only files that should trigger a rebuild
COPY code/src ./src/

# Copy dependencies & project metadata from the previous step
# COPY --from=fetch ./rust-fetch/.cargo-home ./.cargo-home/
# COPY --from=fetch ./rust-fetch/Cargo.toml ./
# COPY --from=fetch ./rust-fetch/Cargo.lock ./

# Copy the target folder from the previous docker build invocation
# This enables incremental compilation
# COPY --from=build ./target ./target

# Run cargo in offline mode so we don't download anything. 
# We already downloaded the dependencies in the 'fetch' step
RUN CARGO_HOME=.cargo-home/ cargo build --offline --release


FROM rust:1.63.0-slim as runtime

COPY --from=build ./rust-build/target/release/test_project ./

EXPOSE 80
ENTRYPOINT ./test_project
