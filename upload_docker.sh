#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`
# Create docker_path
source .env
docker_path=donggiangthai
image_tag='donggiang_store:v1.0.0'
image_name=$(echo $image_tag | cut -f 1 -d ":")
cloud_image_tag=$docker_path/$image_tag

# Step 2:  
# Authenticate & tag
echo "$DOCKER_PASSWORD" | docker login --username $docker_path --password-stdin
image_tagged=$(docker image list --filter=reference=$cloud_image_tag | grep $image_name | xargs)
if [[ -n $image_tagged ]]; then
  echo "Image already tagged, remove the tagged image."
#   name=$(echo "$image_tagged" | cut -f 1 -d " ")
#   tag=$(echo "$image_tagged" | cut -f 2 -d " ")
  docker image remove --force $cloud_image_tag
fi

# image_info=$(docker image list | grep 'project-ml' | xargs)
# image_name=$(echo "$image_info" | cut -f 1 -d " ")
# image_tag=$(echo "$image_info" | cut -f 2 -d " ")
docker image tag $image_tag $cloud_image_tag
docker image list --filter=reference="$cloud_image_tag"

# Step 3:
# Push image to a docker repository
docker image push $cloud_image_tag
