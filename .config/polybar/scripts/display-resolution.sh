#!/usr/bin/env bash

action=$(yad --width 300 --entry --title "Choose display resolution" --text "Choose action:" --entry-text $(ls ~/.screenlayout)); bash ~/.screenlayout/${action}
