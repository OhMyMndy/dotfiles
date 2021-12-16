#!/usr/bin/env bash

set -enable

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
dconf write /org/gnome/settings-daemon/plugins/color/night-light-temperature "uint32 41366164"


dconf write /org/gnome/settings-daemon/plugins/xsettings/antialiasing "'rgba'"
dconf write /org/gnome/settings-daemon/plugins/xsettings/hinting "'medium'"


dconf write /org/virt-manager/virt-manager/system-tray "true"
dconf write /org/virt-manager/virt-manager/xmleditor-enabled "true"

dconf write /org/virt-manager/virt-manager/confirm/delete-storage "true"
dconf write /org/virt-manager/virt-manager/confirm/forcepoweroff "true"
dconf write /org/virt-manager/virt-manager/confirm/removedev "true"
dconf write /org/virt-manager/virt-manager/confirm/unapplied-dev "true"


# (export KEY="/org/gnome/shell/extensions/dash-to-dock/" && dconf dump "$KEY" | awk -F= "(NR>1){ print \"dconf write ${KEY}\"\$1 \" \\\"\" \$2 \"\\\"\"}")
dconf write /org/gnome/shell/extensions/dash-to-dock/animation-time "0.2"
dconf write /org/gnome/shell/extensions/dash-to-dock/apply-custom-theme "true"
dconf write /org/gnome/shell/extensions/dash-to-dock/autohide-in-fullscreen "true"
dconf write /org/gnome/shell/extensions/dash-to-dock/background-opacity "1.0"
dconf write /org/gnome/shell/extensions/dash-to-dock/click-action "'minimize-or-previews'"
dconf write /org/gnome/shell/extensions/dash-to-dock/custom-theme-shrink "true"
dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size "24"
dconf write /org/gnome/shell/extensions/dash-to-dock/dock-fixed "false"
dconf write /org/gnome/shell/extensions/dash-to-dock/dock-position "'BOTTOM'"
dconf write /org/gnome/shell/extensions/dash-to-dock/extend-height "false"
dconf write /org/gnome/shell/extensions/dash-to-dock/force-straight-corner "false"
dconf write /org/gnome/shell/extensions/dash-to-dock/height-fraction "0.9"
dconf write /org/gnome/shell/extensions/dash-to-dock/hide-delay "0"
dconf write /org/gnome/shell/extensions/dash-to-dock/icon-size-fixed "false"
dconf write /org/gnome/shell/extensions/dash-to-dock/intellihide-mode "'FOCUS_APPLICATION_WINDOWS'"
dconf write /org/gnome/shell/extensions/dash-to-dock/middle-click-action "'launch'"
dconf write /org/gnome/shell/extensions/dash-to-dock/multi-monitor "true"
dconf write /org/gnome/shell/extensions/dash-to-dock/pressure-threshold "0.0"
dconf write /org/gnome/shell/extensions/dash-to-dock/scroll-action "'cycle-windows'"
dconf write /org/gnome/shell/extensions/dash-to-dock/shift-click-action "'minimize'"
dconf write /org/gnome/shell/extensions/dash-to-dock/shift-middle-click-action "'launch'"
dconf write /org/gnome/shell/extensions/dash-to-dock/show-mounts "false"
dconf write /org/gnome/shell/extensions/dash-to-dock/show-trash "false"
dconf write /org/gnome/shell/extensions/dash-to-dock/transparency-mode "'FIXED'"