#!/usr/bin/env bash

function getColor() {
echo $(xrdb -query -all | grep -i "$1:" | sed -n 's/.*\(#.*\)/\1/p')
}
color0=$(getColor 'color0')
color1=$(getColor 'color1')
color2=$(getColor 'color2')
color3=$(getColor 'color3')
color4=$(getColor 'color4')
color5=$(getColor 'color5')
color6=$(getColor 'color6')
color7=$(getColor 'color7')
color8=$(getColor 'color8')
color9=$(getColor 'color9')
color10=$(getColor 'color10')
color11=$(getColor 'color11')
color12=$(getColor 'color12')
color13=$(getColor 'color13')
color14=$(getColor 'color14')
color15=$(getColor 'color15')

background=$(getColor 'background')
foreground=$(getColor 'foreground')

cat <<EOF
[global_config]
  enabled_plugins = LaunchpadCodeURLHandler, APTURLHandler, LaunchpadBugURLHandler
  inactive_color_offset = 0.74
  title_font = DroidSansMonoForPowerline Nerd Font 10
  title_hide_sizetext = True
  title_inactive_bg_color = "${foreground}"
  title_inactive_fg_color = "${background}"
  title_receive_bg_color = "${color4}"
  title_transmit_bg_color = "${color2}"
  title_transmit_fg_color = "${background}"
  title_use_system_font = False
[keybindings]
  go_down = <Alt><Super>Down
  go_left = <Alt><Super>Left
  go_right = <Alt><Super>Right
  go_up = <Alt><Super>Up
[layouts]
  [[default]]
    [[[child1]]]
      parent = window0
      profile = xresource
      type = Terminal
    [[[window0]]]
      parent = ""
      type = Window
[plugins]
[profiles]
  [[default]]
    background_color = "${background}"
    cursor_color = "${foreground}"
    foreground_color = "${foreground}"
    palette = "${color2}:${color5}:${color2}:${color1}:${color6}:${color4}:${color3}:${foreground}:${color8}:${color13}:${color10}:${color9}:${color14}:${color12}:${color10}:${color15}"
    scrollback_infinite = True
    custom_command = TERM=xterm-256color zsh
    use_custom_command = True
  [[gruvbox-dark]]
    background_color = "#282828"
    cursor_color = "#7c6f64"
    foreground_color = "#ebdbb2"
    palette = "#181818:#cc241d:#98971a:#d79921:#458588:#b16286:#689d6a:#ebdbb2:#928374:#fb4934:#b8bb26:#fabd2f:#83a598:#d3869b:#8ec07c:#ebdbb2"
    scrollback_infinite = True
  [[gruvbox-light]]
    background_color = "#eee8d5"
    cursor_color = "#002b36"
    foreground_color = "#002b36"
    palette = "#073642:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#002b36:#cb4b16:#586e75:#657b83:#839496:#6c71c4:#93a1a1:#fdf6e3"
    scrollback_infinite = True
  [[solarized-dark]]
    cursor_color = "#eee8d5"
    custom_command = TERM=xterm-256color zsh
    foreground_color = "#eee8d5"
    palette = "#000000:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#0c6075:#cb4b16:#b1cc00:#e3aa00:#2da9ff:#6c71c4:#37d7ca:#fff8e5"
    scrollback_infinite = True
    use_custom_command = True
  [[solarized-light]]
    background_color = "#eee8d5"
    cursor_color = "#002b36"
    foreground_color = "#002b36"
    palette = "#073642:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#002b36:#cb4b16:#586e75:#657b83:#839496:#6c71c4:#93a1a1:#fdf6e3"
    scrollback_infinite = True
  [[xresource]]
    background_color = "${background}"
    cursor_color = "${foreground}"
    foreground_color = "${foreground}"
    palette = "${color2}:${color5}:${color2}:${color1}:${color6}:${color4}:${color3}:${foreground}:${color8}:${color13}:${color10}:${color9}:${color14}:${color12}:${color10}:${color15}"
EOF
