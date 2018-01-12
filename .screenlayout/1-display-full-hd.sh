#!/bin/sh
xrandr --output HDMI2 --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI1 --off --output VIRTUAL1 --off --output DP1 --off

sleep 20
~/bin/restart-polybar