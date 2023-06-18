#!/usr/bin/env nix-shell
#!nix-shell -i bash -p wacomtablet

#setwacom --set "Wacom Intuos Pro L Pad pad"      Rotate half
xsetwacom --set "Wacom Intuos Pro L Pen stylus"   Rotate half
xsetwacom --set "Wacom Intuos Pro L Pen eraser"   Rotate half
xsetwacom --set "Wacom Intuos Pro L Finger touch" Rotate half
xsetwacom --set "Wacom Intuos Pro L Finger touch" Touch  off

xsetwacom --get "Wacom Intuos Pro L Pen stylus" Rotate

