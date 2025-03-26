#!/usr/bin/env bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

sudo apt-get update

# sudo apt-get install flatpak-builder -y
sudo apt-get install apt-file moreutils sshfs inotify-tools pipx htop vim curl wget tree -y

# hardening
sudo apt-get install usbguard usbguard-notifier debsums -y
# sudo debsums -a -s
#
# sudo sh -c 'usbguard generate-policy > /etc/usbguard/rules.conf'
# sudo systemctl enable --now usbguard.service

# XDG utils is needed for gcloud for example
sudo apt-get install -y vim git curl zsh flatpak build-essential \
	xdg-utils flatpak-xdg-utils unzip python3-pip python3-venv

if [[ "$DISPLAY" != '' ]]; then
	sudo snap remove firefox
	flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

	sudo flatpak install flathub org.mozilla.firefox -y
	# flatpak install flathub io.gitlab.librewolf-community
	#
	sudo apt-get install gnome-software gnome-software-plugin-flatpak -y # gnome-software-plugin-snap
	sudo snap remove snap store

fi
#
# dependencies for building Python
sudo apt-get install -y build-essential libssl-dev zlib1g-dev \
	libbz2-dev libreadline-dev libsqlite3-dev curl git \
	libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y
# TODO: only if we have gnome installed
# sudo apt-get install -y gnome-tweaks
