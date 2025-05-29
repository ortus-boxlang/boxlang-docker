#!/bin/bash

IMAGE_VERSION=$(jq -r '.IMAGE_VERSION' version.json)
IMAGE_VERSION=$(echo $IMAGE_VERSION | awk -F. -v OFS=. '{$2++; $3=0; print}')
jq --arg new_version "$IMAGE_VERSION" '.IMAGE_VERSION = $new_version' version.json > version.json.tmp && mv version.json.tmp version.json