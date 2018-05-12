#!/usr/bin/env bash

activeMonitors=$(xrandr --listactivemonitors | tail -n +2 | awk '{print $NF}')
allMonitors=$(xrandr --listmonitors | tail -n +2 | awk '{print $NF}')
allButFirstMonitors=$(xrandr --listmonitors | tail -n +2 | tail -n +2 | awk '{print $NF}')
allButFirstTwoMonitors=$(xrandr --listmonitors | tail -n +2 | tail -n +3 | awk '{print $NF}')
firstMonitor=$(echo "${activeMonitors}" | sed '2d')
secondMonitor=$(echo "${activeMonitors}" | sed '1d')

disableMonitors () {
  monitors="$1"

  result=''
  for monitor in ${monitors}
  do
      result+="--output ${monitor} --off "
  done


  echo "$result"
}
