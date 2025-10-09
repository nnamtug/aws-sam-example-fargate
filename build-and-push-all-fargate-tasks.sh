#!/bin/bash
# Iterate over all subdirectories in the 'fargate' directory and execute build-image.sh and deploy-image-to-fargate.sh if they exist

set -e

FARGATE_DIR="$(dirname "$0")/fargate"

old=$(pwd)
for dir in "$FARGATE_DIR"/*/; do
    echo "Processing $dir"
    cd "$dir"
    echo "Running build-image.sh in $dir"
    ./build-image.sh
    echo "Running deploy-image-to-fargate.sh in $dir"
    ./deploy-image-to-fargate.sh
    cd "$old"
done
