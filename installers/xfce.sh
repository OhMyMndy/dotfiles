#!/usr/bin/env bash

# shellcheck disable=SC2230

function xfce_keybindings() {
	if which xfconf-query &>/dev/null; then
		# Find keyboard shortcuts: xfconf-query -c xfce4-keyboard-shortcuts -l | grep -E '/custom/'

		# # Script to generate the keyboard shortcuts commands from the current setup
		# key=xfce4-keyboard-shortcuts
		# results="$(xfconf-query -c "$key" -l | grep -E '/custom/')"
		# for result in $results;
		# do
		# 	value="$(xfconf-query -c "$key" -p "$result")"
		# 	the_type='string'
		# 	if [[ $value = 'true' ]] || [[ $value = 'false' ]]; then
		# 		the_type='bool'
		# 	fi
		# 	echo "xfconf-query -n -c \"$key\" -p \"$result\" -s \"$value\" -t \"$the_type\""
		# done

		# Clear all keyboard shortcuts
		xfconf-query -c "xfce4-keyboard-shortcuts" -l | xargs -r -i xfconf-query -c "xfce4-keyboard-shortcuts" -p "{}" -r

		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F1" -s "xfce4-popup-applicationsmenu" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F2" -s "xfrun4" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F2/startup-notify" -s "true" -t "bool"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F3" -s "xfce4-appfinder" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F3/startup-notify" -s "true" -t "bool"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>Print" -s "shutter -s" -t "string"

		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>d" -s "rofi -show" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>slash" -s "$HOME/src/splatmoji/splatmoji type" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>s" -s "xfdashboard -t" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Escape" -s "xkill" -t "string"


		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/override" -s "true" -t "bool"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary><Alt>Delete" -s "dm-tool lock" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary><Alt>Escape" -s "xkill" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary>Escape" -s "xfce4-popup-whiskermenu" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/Print" -s "shutter -f" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>e" -s "mousepad" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>f" -s "exo-open --launch FileManager" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>F1" -s "xfce4-find-cursor" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>m" -s "exo-open --launch MailReader" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>p" -s "xfce4-display-settings --minimal" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>r" -s "xfce4-appfinder" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Return" -s "exo-open --launch TerminalEmulator" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>w" -s "exo-open --launch WebBrowser" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/XF86Calculator" -s "mate-calc" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/XF86Display" -s "xfce4-display-settings --minimal" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/XF86Explorer" -s "exo-open --launch FileManager" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/XF86HomePage" -s "exo-open --launch WebBrowser" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/XF86Mail" -s "exo-open --launch MailReader" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/commands/custom/XF86WWW" -s "exo-open --launch WebBrowser" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Alt>F4" -s "close_window_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Alt>grave" -s "switch_window_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Alt>space" -s "popup_menu_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Alt>Tab" -s "cycle_windows_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/Down" -s "down_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/Escape" -s "cancel_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/Left" -s "left_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/override" -s "true" -t "bool"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Alt>d" -s "show_desktop_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Shift><Alt>Left" -s "move_window_left_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Shift><Alt>Right" -s "move_window_right_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Shift><Alt>Up" -s "move_window_up_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/Right" -s "right_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Alt>ISO_Left_Tab" -s "cycle_reverse_windows_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>ampersand" -s "move_window_workspace_7_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>asciicircum" -s "move_window_workspace_6_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>asterisk" -s "move_window_workspace_8_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>at" -s "move_window_workspace_2_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>dollar" -s "move_window_workspace_4_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>exclam" -s "move_window_workspace_1_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>numbersign" -s "move_window_workspace_3_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>parenleft" -s "move_window_workspace_9_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>parenright" -s "move_window_workspace_10_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>percent" -s "move_window_workspace_5_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>0" -s "workspace_10_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>1" -s "workspace_1_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>2" -s "workspace_2_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>3" -s "workspace_3_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>4" -s "workspace_4_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>5" -s "workspace_5_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>6" -s "workspace_6_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>7" -s "workspace_7_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>8" -s "workspace_8_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>9" -s "workspace_9_key" -t "string"
		xfconf-query -n -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/Up" -s "up_key" -t "string"
	fi
}


function xfce_settings() {
	if which xfconf-query &>/dev/null; then
		# Execute executables in Thunar instead of editing them on double click: https://bbs.archlinux.org/viewtopic.php?id=194464
		xfconf-query --channel thunar --property /misc-exec-shell-scripts-by-default --create --type bool --set true

		# XFT
		xfconf-query -c xsettings -p /Xft/Antialias -s 1
		xfconf-query -c xsettings -p /Xft/Hinting -s 1
		xfconf-query -c xsettings -p /Xft/HintStyle -s "hintslight"
		xfconf-query -c xsettings -p /Xft/Lcdfilter -s "lcddefault"
		xfconf-query -c xsettings -p /Xft/RGBA -s "rgb"


		xfconf-query -c xsettings -p /Gtk/FontName -s "IBM Plex Sans Medium 10"
		xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "JetBrainsMono Nerd Font Mono 10"
		xfconf-query -c xsettings -p /Gtk/DecorationLayout -s "menu:minimize,maximize,close"

		xfconf-query -c xsettings -p /Gtk/ButtonImages -s true

		xfconf-query -c xfwm4 -p /general/title_font -s "IBM Plex Sans Medium 10"
		xfconf-query -c xfwm4 -p /general/button_layout -s "O|HMC"
		xfconf-query -c xfwm4 -p /general/cycle_preview -s false
		xfconf-query -c xfwm4 -p /general/mousewheel_rollup -s false
		xfconf-query -c xfwm4 -p /general/workspace_names -n -t string -t string -t string -t string -t string -t string -t string -t string -t string -t string -s "1" -s "2" -s "3" -s "4" -s "5" -s "6" -s "7" -s "8" -s "9" -s "10"
		xfconf-query -c xfwm4 -p /general/workspace_count -s 4


 		xfconf-query -c xfce4-session -p /compat/LaunchGNOME -s true

		# Notifyd
		xfconf-query -n -c xfce4-notifyd -p /log-level -t int -s 1
		xfconf-query -n -c xfce4-notifyd -p /log-level-apps -t int -s 0
		xfconf-query -n -c xfce4-notifyd -p /notification-log -t bool -s true
		xfconf-query -n -c xfce4-notifyd -p /notify-location -t int -s 2
		xfconf-query -n -c xfce4-notifyd -p /primary-monitor -t int -s 0
		xfconf-query -n -c xfce4-notifyd -p /theme -t string -s Greybird

		# Keyboard
		xfconf-query -n -c keyboards -p /Default/KeyRepeat/Delay -t int -s 300
		xfconf-query -n -c keyboards -p /Default/KeyRepeat/Rate -t int -s 26

		xfconf-query -n -c keyboard-layout -p /Default/XkbDisable -t bool -s false
		xfconf-query -n -c keyboard-layout -p /Default/XkbLayout -t string -s us
		xfconf-query -n -c keyboard-layout -p /Default/XkbVariant -t string -s altgr-intl

		# Thunar volman
		xfconf-query -n -c thunar-volman -p /autoplay-audio-cds/enabled -t bool -s false
		#xfconf-query -n -c thunar-volman -p /autoplay-audio-cds/command -t string -s "vlc cdda://%d"
		xfconf-query -n -c thunar-volman -p /autoplay-video-cds/enabled -t bool -s false
		#xfconf-query -n -c thunar-volman -p /autoplay-video-cds/command -t string -s "vlc dvd://%d"
		xfconf-query -n -c thunar-volman -p /autorun/enabled -t bool -s true
	fi

	if command -v xfce4-panel &>/dev/null; then
		xfce4-panel -r
	fi
}

function xfce_settings-dark() {
if command -v xfconf-query &>/dev/null
	then
		xfconf-query -c xsettings -p /Net/ThemeName -s Arc-Dark
		# xfconf-query -c xsettings -p /Net/IconThemeName -s Pocillo
		xfconf-query -c xsettings -p /Net/IconThemeName -s Papirus-Dark
		xfconf-query -c xfwm4 -p /general/theme -s Bluebird
	fi

}

function xfce_settings-light() {
	if command -v xfconf-query &>/dev/null
	then
		xfconf-query -c xsettings -p /Net/ThemeName -s Adwaita
		xfconf-query -c xsettings -p /Net/IconThemeName -s Papirus-Light
		xfconf-query -c xfwm4 -p /general/theme -s Bluebird
	fi
}


function wm_i3() {
	
	set_autostart_hidden xfwm4.desktop true
	set_autostart_hidden xfdesktop.desktop true

	xfconf-query --channel xfce4-session --property /sessions/Failsafe/Client0_Command --type string --set "i3" --force-array

	# cp ~/.local/share/applications/Polybar.desktop ~/.config/autostart/
	#sed -Ei 's#Hidden=.*#Hidden=false#g' ~/.config/autostart/Polybar.desktop

	cp ~/.local/share/applications/Compton.desktop ~/.config/autostart/
	set_autostart_hidden Compton.desktop false


	pkill -e xfdesktop
	# pkill -e xfce4-panel
	pkill -e xfwm4
	pkill -e polybar
	pkill -e i3
	# pkill -e polybar
	nohup i3 -c ~/.config/i3/config &>/dev/null & disown
	sleep 2
	nohup compton --config ~/.config/compton/compton.conf &>/dev/null & disown
	# polybar -r top &>/dev/null &

	nohup xfce4-panel &>/dev/null & disown

	move_windows_to_workspace
}

function move_windows_to_workspace() {
	i3-msg '[class="Google-chrome"]' move to workspace 1
	i3-msg '[class="Chromium"]' move to workspace 1

	i3-msg '[class="Alacritty"]' move to workspace 2

	i3-msg '[class="Code"]' move to workspace 4
	i3-msg '[class="PhpStorm"]' move to workspace 4
	i3-msg '[class="(?i).*jetbrains.*"]' move to workspace 4


	i3-msg '[class="discord"]' move to workspace 6
	i3-msg '[class="Slack"]' move to workspace 6
	i3-msg '[class="Skype"]' move to workspace 6


	i3-msg '[class="Xfdesktop"]' move to scratchpad
}

function wm_xfwm() {
	set_autostart_hidden xfdesktop.desktop false
	set_autostart_hidden xfwm4.desktop false
	set_autostart_hidden xfce4-panel.desktop false
	set_autostart_hidden i3.desktop true
	rm ~/.config/autostart/Polybar.desktop

	pkill -e i3
	pkill -e polybar

	# restart ulauncher to rebind Meta+Space
	pkill -e -f ulauncher
	nohup ulauncher &>/dev/null & disown
	
	pkill -e -f quicktile
	nohup quicktile --daemonize &>/dev/null & disown

	nohup copyq  &>/dev/null & disown

	nohup compton --config ~/.config/compton/compton.conf &>/dev/null & disown

	xfconf-query --channel xfce4-session --property /sessions/Failsafe/Client0_Command --type string --set "xfwm4" --force-array
	nohup xfwm4 &>/dev/null & disown
	nohup xfce4-panel &>/dev/null & disown
}