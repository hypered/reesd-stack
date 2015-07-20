#! /bin/bash

# Helper script for build-in-vm.sh.

set -e

function log {
  echo "$(date --iso-8601=seconds --utc) $1"
}

log "Cloning the repositories..."
git clone git@github.com:noteed/reesd-stack

log "Building images..."
pushd reesd-stack
./build.sh
popd
