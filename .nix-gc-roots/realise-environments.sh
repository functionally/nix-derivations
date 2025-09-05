#!/usr/bin/env bash

ee="chessEnv cloudEnv commEnv dataEnv deskEnv fontEnv netEnv termEnv texEnv toolEnv gameEnv vimEnv rustEnv vscodeEnv"

case "$(hostname)" in
  "oryx")
    ee+=" nativeGraphicalEnv";;
  "thelio")
    ee+=" nativeServerEnv";;
  *)
    ee+=" hostedServerEnv";;
esac

for e in $ee
do
  set +e
  rm $PWD/$e{.drv,.env} >& /dev/null
  set -e
  nix-store --realise $(nix-instantiate '<nixpkgs>' --attr $e --indirect --add-root $PWD/$e.drv) --indirect --add-root $PWD/$e.env
done
