#!/usr/bin/env bash

image_tag='donggiang_store:v1.0.0'
container_name=$(echo $image_tag | cut -f 1 -d ":")

# Remove backup image
docker image remove --force $image_tag-backup 2>&1

exist_image=$(docker image list $image_tag | grep $container_name)
if [[ -n $exist_image ]]; then
    exist_container=$(docker container list --all --filter "name=$container_name" | grep $container_name)
    if [[ -n $exist_container ]]; then
        docker container stop $container_name 2>&1
        docker container rm --force $container_name 2>&1
    fi
    # Tag new image to back up
    docker image tag $image_tag $image_tag-backup
    # Remove current image
    docker image remove --force $image_tag 2>&1
fi

# Build the docker image
docker image build --tag $image_tag .
if [[ $? -ne 0 ]]; then
    echo "Docker image build failed"
    exit 1
fi

# Run the docker container
docker container run --name donggiang_store --publish 8000:8000 \
    --interactive --tty --detach \
    --env-file .env \
    $image_tag 2>&1
