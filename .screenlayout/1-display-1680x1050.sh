#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
source "$DIR/.functions.sh"

disabledMonitors=$(disableMonitors "${allButFirstMonitors}")
xrandr --output ${firstMonitor} --mode 1680x1050 --pos 0x0 --rotate normal ${disabledMonitors}
