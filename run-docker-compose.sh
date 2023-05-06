#!/usr/bin/env bash

# Get command-line arguments
aws_profile_name="$1"
shift
env="$1"
shift
tag_key="$1"
shift

# Handle variable
if [[ -z $aws_profile_name ]]; then
  aws_profile_name='capstone'
fi
if [[ -z $tag_key ]]; then
  tag_key='v1.0.0'
fi
docker_compose_file='docker-compose.yml'
if [[ -n $env ]]; then
  docker_compose_file="docker-compose.$env.yml"
fi

# Clear the dangling image
docker image prune --filter "dangling=true" --force

# Down the compose
#docker-compose down -v

# Build the image
docker-compose --file "$docker_compose_file" --project-name "donggiang_store_local" build \
  --build-arg profile=$aws_profile_name

# Get the docker hub password from the secret env file
source .secret/.env
# Docker Hub ID
docker_path=donggiangthai
# Login to docker hub
echo "$DOCKER_PASSWORD" | docker login --username $docker_path --password-stdin
# Push image to docker hub
#docker-compose --file "$docker_compose_file" --project-name "donggiang_store_local" push

# Run docker compose command
docker-compose --file "$docker_compose_file" --project-name "donggiang_store_local" up --detach --no-build