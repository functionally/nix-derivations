#!/usr/bin/env nix-shell
#!nix-shell -i bash -p wacomtablet

xsetwacom --set "Wacom Intuos Pro L Pen stylus" Rotate half

xsetwacom --get "Wacom Intuos Pro L Pen stylus" Rotate

