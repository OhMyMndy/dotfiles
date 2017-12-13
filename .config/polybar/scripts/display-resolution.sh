#!/usr/bin/env bash

pkill -f "Choose display resolution" -9
action=$(yad --width 300 --entry --title "Choose display resolution" --text "Choose action:" --entry-text $(ls ~/.screenlayout)); bash ~/.screenlayout/${action}
