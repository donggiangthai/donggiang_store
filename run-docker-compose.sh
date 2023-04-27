#!/usr/bin/env bash

# Clear the dangling image
docker image prune --filter "dangling=true" --force

# Down the compose
docker-compose down -v

# Run docker compose command
docker-compose --file docker-compose.yml up --detach --build