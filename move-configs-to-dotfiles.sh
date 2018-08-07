#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/.functions"
source "$DIR/.zshrc" 2>/dev/null


rm "$DIR/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
move-to-dotfiles ".config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"

rm "$DIR/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml"
move-to-dotfiles ".config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml"