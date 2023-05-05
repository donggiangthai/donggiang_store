#!/usr/bin/env bash
# For local

# Get command-line arguments
aws_profile_name="$1"
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

image_tag="donggiang_store:$tag_key"
container_name=$(echo $image_tag | cut -f 1 -d ":")

# Remove backup image
docker image remove --force $image_tag-backup 2>&1

# If image is existed then check for existing container and remove if it is existed
exist_image=$(docker image list $image_tag | grep "$container_name")
if [[ -n $exist_image ]]; then
  exist_container=$(docker container list --all --filter "name=$container_name" | grep "$container_name")
  if [[ -n $exist_container ]]; then
    # Stop and remove the existed container
    docker container stop "$container_name" 2>&1
    docker container rm --force "$container_name" 2>&1
  fi
  # Tag the existing image for backing up
  docker image tag $image_tag $image_tag-backup
  # Remove the current image
  docker image remove --force $image_tag 2>&1
fi

# Build the new docker image
echo docker image build --build-arg profile=$aws_profile_name --tag $image_tag .
docker image build --build-arg profile=$aws_profile_name --tag $image_tag .
if [[ $? -ne 0 ]]; then
  echo "Docker image build failed"
  exit 1
fi

# Run the docker container
docker container run --name donggiang_store --publish 8000:8000 \
  --interactive --tty --detach \
  --env-file .env \
  --volume "$HOME"/.aws/credentials:/home/app/.aws/credentials:ro \
  $image_tag 2>&1
