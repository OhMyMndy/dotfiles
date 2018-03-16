#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
source .functions.sh

disabledMonitors=$(disableMonitors "${allButFirstMonitors}")
xrandr --output ${firstMonitor} --mode 1920x1080 --pos 0x0 --rotate normal ${disabledMonitors}
