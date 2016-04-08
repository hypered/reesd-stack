#! /bin/bash

cabal update
sed -i 's/hackage.haskell.org/hackage.reesd.com/' /home/gusdev/.cabal/config
sed -i 's/hackage.haskell.org\/packages\/archive/hackage.reesd.com\//' /home/gusdev/.cabal/config
cabal update

cd /home/gusdev/stack-dependencies
cabal install -f-integer-simple text-1.2.1.3
cabal install alex happy
cabal install --only-dependencies
