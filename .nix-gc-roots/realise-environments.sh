#!/usr/bin/env bash

ee="ghcEnv8107 haskellEnv pythonEnv rEnv stardog stella-simulator tor-browser-bundle-bin-unstable"

case "$(hostname)" in
  "lemur")
    ee+=" nativeGraphicalEnv";;
  "gazelle")
    ee+=" nativeServerEnv";;
  *)
    ee+=" hostedServerEnv";;
esac

for e in $ee
do
  echo $e
  rm $PWD/$e{.drv,}
  nix-store --realise $(nix-instantiate '<nixpkgs>' --attr $e --indirect --add-root $PWD/$e.drv) --indirect --add-root $PWD/$e
done
