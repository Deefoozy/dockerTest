FROM rust:1.63.0-slim as runtime

EXPOSE 80
ENTRYPOINT /etc/test_project
