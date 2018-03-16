#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
source .functions.sh

disabledMonitors=$(disableMonitors "${allButFirstTwoMonitors}")

if [ "${secondMonitor}" != '' ]; then
  xrandr --output ${firstMonitor} --mode 1920x1080 --pos 0x0 --rotate normal --output ${secondMonitor} --primary --mode 1920x1080 --pos 1920x0 --rotate normal ${disabledMonitors}
fi
