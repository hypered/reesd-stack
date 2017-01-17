#! /bin/bash

generate-build-depends () {
cat $1 \
  | sed -e 's/ .*$//' \
  | sed -e 's/-\([^-]*\)$/ == \1,/' \
  | sed '$ s/.$//' \
  | sed  's/^/    /' \
  > images/stack-dependencies/$2
}

generate-build-depends stackage-lts-2.22-ghc-7.8.4.txt  build-depends.lts-2.22
generate-build-depends stackage-lts-6.27-ghc-7.10.3.txt build-depends.lts-6.27
generate-build-depends stackage-lts-7.15-ghc-8.0.1.txt  build-depends.lts-7.15

#
# Base images (builders)
#

#  --no-cache \

docker build \
  -f images/stack-dependencies/Dockerfile-7.8.4 \
  -t images.reesd.com/reesd/stack-dependencies:7.8.4 \
  images/stack-dependencies

docker build \
  -f images/stack-dependencies/Dockerfile-7.10.3 \
  -t images.reesd.com/reesd/stack-dependencies:lts-7.10.3 \
  images/stack-dependencies

#
# Target images
#

#docker build \
#  -t images.reesd.com/reesd/stack:7.8.4 \
#  images/stack-7.8.4

#docker build \
#  -t images.reesd.com/reesd/stack:lts-7.8.4 \
#  images/stack-lts-7.8.4

docker build \
  -t images.reesd.com/reesd/stack:lts-7.8.4-reesd \
  images/stack-lts-7.8.4-reesd

#docker build \
#  -t images.reesd.com/reesd/stack:lts-7.10.3 \
#  images/stack-lts-7.10.3

#docker build \
#  -t images.reesd.com/reesd/stack:lts-7.10.3 \
#  images/stack-lts-7.10.3


# I guess the LTS-based one is as good as mine.
docker tag -f images.reesd.com/reesd/stack:lts-7.8.4-reesd images.reesd.com/reesd/stack:7.8.4
