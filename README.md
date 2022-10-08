#### initial setup
``docker compose up -d``

#### rebuild a container
This will rebuild & recreate just the container specified (assuming other containers are still running)
``docker compose up -d --force-recreate --build {{container name}}``
