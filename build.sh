#! /bin/bash

docker build \
  --no-cache \
  -t images.reesd.com/reesd/stack-dependencies:7.8.4 \
  images/stack-dependencies

docker build \
  -t images.reesd.com/reesd/stack:7.8.4 \
  images/stack
