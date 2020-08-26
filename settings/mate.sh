#!/usr/bin/env bash

set -e


function write_settings() {
    local config="$1"
    local path="$2"
    echo "$config" | while read -r line || [[ -n $line ]];
    do
        IFS="="
        read -r -a strarr <<< "$line"
        dconf write "$path/${strarr[0]}" "${strarr[1]}"
    done
}

read -r config <<'EOF'
allow-bold=true
background-color='#000000000000'
bold-color='#000000000000'
bold-color-same-as-fg=true
copy-selection=true
default-show-menubar=false
foreground-color='#FFFFFFFFFFFF'
palette='#000000000000:#CDCD00000000:#0000CDCD0000:#CDCDCDCD0000:#1E1D9090FFFF:#CDCD0000CDCD:#0000CDCDCDCD:#E5E4E5E4E5E4:#88888A8A8585:#FFFF00000000:#0000FFFF0000:#FFFFFFFF0000:#46468282B4B3:#FFFF0000FFFF:#0000FFFFFFFF:#FFFFFFFFFFFF'
scrollback-lines=1024
scrollbar-position='hidden'
title-mode='after'
use-theme-colors=false
visible-name='Default'
EOF
write_settings "$config" "/org/mate/terminal/profiles/default"


read -r config <<'EOF'
dark-theme=false
favourites=['caja-file-management-properties.desktop', 'code_code.desktop']
label-visible=true
window-type='classic'
EOF
write_settings "$config" "/com/solus-project/brisk-menu"


read -r config <<'EOF'
run-command-terminal='<Mod4>Return'
switch-to-workspace-1='<Mod4>1'
switch-to-workspace-2='<Mod4>2'
switch-to-workspace-3='<Mod4>3'
switch-to-workspace-4='<Mod4>4'
switch-to-workspace-down='disabled'
switch-to-workspace-right='disabled'
switch-to-workspace-left='disabled'
switch-to-workspace-up='disabled'
EOF
write_settings "$config" "/org/mate/marco/global-keybindings"



write_settings "cursor-theme='mate'" /org/mate/desktop/peripherals/mouse
write_settings "exec='alacritty'" /org/mate/desktop/applications/terminal
write_settings "exec='onboard'" /org/mate/desktop/applications/at/mobility


write_settings "popup-location='top_right'" /org/mate/notification-daemon
write_settings "theme='slider'" /org/mate/notification-daemon

write_settings "screensaver='<Mod4>Delete'" /org/mate/settings-daemon/plugins/media-keys

