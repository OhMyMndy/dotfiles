#!/usr/bin/env bash

read -r -d '' config <<'EOF'
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


echo "$config" | while read line || [[ -n $line ]];
do
    IFS="="
    read -a strarr <<< "$line"
    dconf write "/org/mate/terminal/profiles/default/${strarr[0]}" "${strarr[1]}"
done


read -r -d '' config <<'EOF'
dark-theme=false
favourites=['caja-file-management-properties.desktop', 'code_code.desktop']
label-visible=true
window-type='classic'
EOF
echo "$config" | while read line || [[ -n $line ]];
do
    IFS="="
    read -a strarr <<< "$line"
    dconf write "/com/solus-project/brisk-menu/${strarr[0]}" "${strarr[1]}"
done