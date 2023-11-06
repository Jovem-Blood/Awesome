#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

xrandr --output DisplayPort-0 --primary --left-of HDMI-A-0
run copyq
run nitrogen --restore
run nm-applet
run blueman-applet

xrandr --output HDMI-1 --mode 1920x1080 --pos 1931x0 --rotate normal --output DP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
# export QT_STYLE_OVERRIDE=qt5ct-style
# export QT_QPA_PLATFORMTHEME=qt5ct
