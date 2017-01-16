#! /bin/bash

cabal update
sed -i 's/hackage.haskell.org/hackage.reesd.com/' /home/gusdev/.cabal/config
sed -i 's/hackage.haskell.org\/packages\/archive/hackage.reesd.com\//' /home/gusdev/.cabal/config
cabal update

cd /home/gusdev/stack-dependencies
echo
echo ------ Installing text...
cabal install -f-integer-simple text-1.2.1.3
echo
echo ------ Installing QuickCheck
# Otherwise alex or happy will install a more recent QuickCheck.
cabal install QuickCheck-2.8.2
echo
echo ------ Installing alex, happy...
cabal install alex happy
echo
echo ------ Installing remaing packages...
cabal install --only-dependencies
