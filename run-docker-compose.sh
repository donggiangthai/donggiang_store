#!/usr/bin/env bash

declare -r env="$1"; shift

docker_compose_file='docker-compose.yml'
if [[ -n $env ]]; then
  docker_compose_file="docker-compose.$env.yml"
fi

# Clear the dangling image
docker image prune --filter "dangling=true" --force

# Down the compose
#docker-compose down -v

# Run docker compose command
docker-compose --file "$docker_compose_file" up --detach --build