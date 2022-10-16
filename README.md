#### initial setup
``docker compose up -d``

#### rebuild a container with docker compose
This will rebuild & recreate just the container specified (assuming other containers are still running)
``docker compose up -d --force-recreate --build {{container name}}``

#### Rebuild a container without docker compose
``docker build --build-arg build_profile=release --build-arg compile_target=test_project -f .\rust.Dockerfile .``
