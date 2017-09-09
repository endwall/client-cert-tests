#! /bin/bash

set -ex

APP_NAME=simple-express-client
build_time=$(date +%Y-%m-%d:%H:%M:%S)
build_version=3

docker build -t $APP_NAME \
  -t $APP_NAME:$build_version \
  --build-arg build_version=${build_version} \
  --build-arg build_time="${build_time}" .