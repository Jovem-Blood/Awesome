#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

run nm-applet
run kdeconnect-indicator
run copyq
run $HOME/bin/ondrc.sh
run picom --config $HOME/.config/awesome/picom.conf
run touchpad
run nitrogen --restore
