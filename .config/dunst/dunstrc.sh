#!/usr/bin/env bash

function getColor() {
	echo $(xrdb -query | awk "/$1:/ { print \$2 }")
	#echo $(xrdb -query -all | grep -i "$1:" | sed -n 's/.*\(#.*\)/\1/p')
}
color0=$(getColor 'color0')
color1=$(getColor 'color1')
color2=$(getColor 'color2')
color3=$(getColor 'color3')
color4=$(getColor 'color4')
color5=$(getColor 'color5')
background=$(getColor 'background')
foreground=$(getColor 'foreground')

cat <<EOF
[global]
    font = "DroidSansMonoForPowerline Nerd Font 9"
    allow_markup = yes
    format = "<b>%a</b>\n<b><i>%s</i></b>\n%b"
    sort = yes
    indicate_hidden = yes
    alignment = left
    bounce_freq = 0
    show_age_threshold = 90
    word_wrap = yes
    ignore_newline = no
    geometry = "360x6-6+32"
    transparency = 0
    idle_threshold = 90
    monitor = 0
    follow = mouse
    sticky_history = yes
    line_height = 0
    separator_height = 2
    padding = 12
    horizontal_padding = 12
    separator_color = "${color4}"
    startup_notification = false
    # https://github.com/knopwob/dunst/issues/26#issuecomment-36159395
    #icon_position = left
    #icon_folders = /usr/share/icons/elementary/actions/16/

[frame]
    width = 2
    color = "${color2}"

[shortcuts]
    close = ctrl+space
    close_all = ctrl+shift+space
    history = ctrl+grave
    context = ctrl+shift+period

[urgency_low]
    background = "${color0}"
    foreground = "${foreground}"
    timeout = 5

[urgency_normal]
    background = "${color0}"
    foreground = "${color2}"
    timeout = 20

[urgency_critical]
    background = "${color0}"
    foreground = "${color5}"
    timeout = 0
EOF
