#! /bin/bash

set -e

generate-build-depends () {
cat $1 \
  | sed -e 's/ .*$//' \
  | sed -e 's/-\([^-]*\)$/ == \1,/' \
  | sed '$ s/.$//' \
  | sed  's/^/    /' \
  > /home/gusdev/stack-dependencies/$2
}

generate-build-depends stackage-lts-2.22-ghc-7.8.4.txt        build-depends.lts-2.22
generate-build-depends stackage-lts-6.27-ghc-7.10.3.txt       build-depends.lts-6.27
generate-build-depends stackage-lts-6.31-ghc-7.10.3-reesd.txt build-depends.lts-6.31-reesd
generate-build-depends stackage-lts-7.15-ghc-8.0.1.txt        build-depends.lts-7.15
generate-build-depends stackage-lts-9.21-ghc-8.0.2-reesd.txt  build-depends.lts-9.21-reesd
