#! /bin/bash

docker build \
  --no-cache \
  -t images.reesd.com/reesd/stack-dependencies \
  images/stack-dependencies

docker build \
  -t images.reesd.com/reesd/stack \
  images/stack
