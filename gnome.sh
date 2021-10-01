#!/usr/bin/env bash

set -e
# sudo apt-get update -y -qq
# sudo apt-get install git node-typescript make -y -qq

# mkdir -p ~/src && cd ~/src
# git clone https://github.com/pop-os/shell.git pop-os-shell | true
# cd ~/src/pop-os-shell
# git pull

# yes | make local-install


dconf write /org/gnome/desktop/wm/keybindings/switch-windows "['<Alt>Tab']"
dconf write /org/gnome/desktop/wm/keybindings/switch-windows-backward "['<Alt><Shift>Tab']"
dconf write /org/gnome/desktop/wm/preferences/button-layout "'icon:minimize,maximize,close'"
dconf write /org/gnome/desktop/wm/preferences/resize-with-right-button "true"


dconf write /org/gnome/desktop/interface/clock-show-weekday "true"
dconf write /org/gnome/desktop/interface/enable-animations "false"
dconf write /org/gnome/gedit/plugins/active-plugins "['modelines', 'time', 'spell', 'filebrowser', 'docinfo']"
dconf write /org/gnome/mutter/workspaces-only-on-primary "false"



dconf write /org/gnome/nautilus/preferences/default-folder-viewer "'list-view'"
dconf write /org/gnome/nautilus/preferences/executable-text-activation "'ask'"
dconf write /org/gnome/nautilus/preferences/recursive-search "'always'"
dconf write /org/gnome/nautilus/preferences/search-filter-time-type "'last_modified'"
dconf write /org/gnome/nautilus/preferences/show-create-link "true"
dconf write /org/gnome/nautilus/preferences/show-delete-permanently "true"




dconf write /org/gnome/settings-daemon/plugins/color/night-light-enabled "true"
dconf write /org/gnome/settings-daemon/plugins/color/night-light-schedule-automatic "false"
dconf write /org/gnome/settings-daemon/plugins/color/night-light-schedule-from "0.0"
dconf write /org/gnome/settings-daemon/plugins/color/night-light-schedule-to "23.983333333333334"
dconf write /org/gnome/settings-daemon/plugins/color/night-light-temperature "uint32 4164"


dconf write /org/gnome/settings-daemon/plugins/xsettings/antialiasing "'rgba'"
dconf write /org/gnome/settings-daemon/plugins/xsettings/hinting "'medium'"


dconf write /org/virt-manager/virt-manager/system-tray "true"
dconf write /org/virt-manager/virt-manager/xmleditor-enabled "true"

dconf write /org/virt-manager/virt-manager/confirm/delete-storage "true"
dconf write /org/virt-manager/virt-manager/confirm/forcepoweroff "true"
dconf write /org/virt-manager/virt-manager/confirm/removedev "true"
dconf write /org/virt-manager/virt-manager/confirm/unapplied-dev "true"



dconf write /org/gnome/shell/extensions/dash-to-dock/apply-custom-theme "true"
dconf write /org/gnome/shell/extensions/dash-to-dock/background-opacity "1.0"
dconf write /org/gnome/shell/extensions/dash-to-dock/click-action "'minimize-or-previews'"
dconf write /org/gnome/shell/extensions/dash-to-dock/custom-theme-shrink "true"
dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size "24"
dconf write /org/gnome/shell/extensions/dash-to-dock/dock-fixed "true"
dconf write /org/gnome/shell/extensions/dash-to-dock/dock-position "'LEFT'"
dconf write /org/gnome/shell/extensions/dash-to-dock/extend-height "true"
dconf write /org/gnome/shell/extensions/dash-to-dock/force-straight-corner "false"
dconf write /org/gnome/shell/extensions/dash-to-dock/height-fraction "0.90000000000000002"
dconf write /org/gnome/shell/extensions/dash-to-dock/icon-size-fixed "false"
dconf write /org/gnome/shell/extensions/dash-to-dock/middle-click-action "'launch'"
dconf write /org/gnome/shell/extensions/dash-to-dock/multi-monitor "true"
dconf write /org/gnome/shell/extensions/dash-to-dock/scroll-action "'cycle-windows'"
dconf write /org/gnome/shell/extensions/dash-to-dock/shift-click-action "'minimize'"
dconf write /org/gnome/shell/extensions/dash-to-dock/shift-middle-click-action "'launch'"
dconf write /org/gnome/shell/extensions/dash-to-dock/show-mounts "false"
dconf write /org/gnome/shell/extensions/dash-to-dock/show-trash "false"
dconf write /org/gnome/shell/extensions/dash-to-dock/transparency-mode "'FIXED'"