#!/usr/bin/env bash

ee="haskellEnv ghcEnv7 pythonEnv rEnv"

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
