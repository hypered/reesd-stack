# Reesd Stack

This repository is used to create Docker images that are essentially Haskell
compilers, batteries included. It can be compared to a custom Haskell Platform
or a custom Stackage snapshot.

For reference, here are the packages obtained the last time I built the image:

    > docker run images.reesd.com/reesd/stack > packages.txt

(This contains a fairly recent Hackage subset.)

## Motivation

For [Reesd](https://reesd.com) we have a small but growing Haskell code base
where we try to create small and reusable programs and libraries. We need that
different libraries can be linked together and thus require that we have a
consistent set of dependencies.

Because the Haskell packages that we depend on have different versioning
policies (e.g. respect or not the PVP), and because it was not a priority to
follow all the latest versions, we started to pin some dependencies versions
(and live more and more in the past).

This repository is here to help us list (and pin) dependencies, build them
together from time to time to detect new incompatibilities, and experiment in
trying to adopt more recent packages.

Currently we are using a dummy program with a `.cabal` file (which list the
dependencies that we want, even if none of them is necessary for the dummy
program).

## `images/stack-dependencies`

This is both a cabalized Haskell project and a Docker image. The .cabal file
describes a dummy project (i.e. the project is empty and doesn't matter) and
gives a list of dependencies to be built together.

When the Docker image is run, it builds the dependencies. This can be done
from time to time to make sure everything continues to work together. When the
image can't be built, it usually means that some new package has appeared on
Hackage, is picked up by Cabal, which ends up in conflict. As conflicts arise,
additional packages are pinned.

## `images/stack`

A Docker container that built the dependencies (see above) can be commited to
an image. That image can be used as a binary distribution of a customized
Haskell Platform, or a batteries-included, self-contained GHC. `images/stack`
is such a committed container.

## Usage

First build the Docker image with the dummy Cabal project:

    > docker build images/stack-dependencies images/stack-dependencies

Once the image is built, it can be run to `cabal update` and build all the
dependencies. This is what the second Dockerfile do. Note that the second
Dockerfile refer to the first image as
`images.reesd.com/reesd/stack-dependencies`. You can either tag it as such, or
change the first line of the second Dockerfile.

    > docker build images/stack
    ...
    Successfully built e7d3c36655

Possible usage of the resulting image:

    > docker run e7d3c36655 ghc-pkg list
    > docker run -t -i e7d3c36655 ghci
    > docker run -v `pwd`:/source e7d3c36655 sh -c 'cd /source ; cabal install'

Normally the second image ID is tagged as `images.reesd.com/reesd/stack`.
