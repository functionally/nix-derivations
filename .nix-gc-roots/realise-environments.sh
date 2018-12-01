#!/usr/bin/env bash

ee="ghcEnv7 ghcEnv8 haskellEnv juliaEnv pythonEnv rEnv stardog stella-simulator"

case "$(hostname)" in
  "lemur")
    ee+=" nativeGraphicalEnv unityEnv";;
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
