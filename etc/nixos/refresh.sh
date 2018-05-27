#!/usr/bin/env bash

HOSTNAME=$(hostname)

cp /etc/nixos/{generic-configuration,system-packages,desktop-packages}.nix .

if [ ! -d $HOSTNAME ]
then
  mkdir $HOSTNAME
fi

cp /etc/nixos/{,hardware-}configuration.nix $HOSTNAME/
