#! /bin/bash

#
# Base images (builders)
#


#docker build \
#  -f images/stack-dependencies/Dockerfile-7.8.4 \
#  -t images.reesd.com/reesd/stack-dependencies:7.8.4 \
#  images/stack-dependencies

docker build \
  --no-cache \
  -f images/stack-dependencies/Dockerfile-7.10.3 \
  -t images.reesd.com/reesd/stack-dependencies:lts-7.10.3 \
  images/stack-dependencies

#
# Target images
#

#docker build \
#  -f images/stack/Dockerfile-7.8.4 \
#  -t images.reesd.com/reesd/stack:7.8.4 \
#  images/stack

#docker build \
#  -f images/stack/Dockerfile-lts-7.8.4 \
#  -t images.reesd.com/reesd/stack:lts-7.8.4 \
#  images/stack

# The good one.
# ------------
#docker build \
#  -f images/stack/Dockerfile-lts-7.8.4-reesd \
#  -t images.reesd.com/reesd/stack:lts-7.8.4-reesd \
#  images/stack

docker build \
  -f images/stack/Dockerfile-lts-7.10.3-reesd \
  -t images.reesd.com/reesd/stack:lts-7.10.3-reesd \
  images/stack


# Uncomment when rebuilding.
# docker tag -f images.reesd.com/reesd/stack:lts-7.8.4-reesd images.reesd.com/reesd/stack:7.8.4
# docker tag -f images.reesd.com/reesd/stack:lts-7.10.3-reesd images.reesd.com/reesd/stack:7.10.3
