#!/usr/bin/env bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

sudo apt-get update
sudo apt-get install -y git curl zsh flatpak

snap remove firefox
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install flathub org.mozilla.firefox -y

# TODO: only if we have gnome installed
# sudo apt-get install -y gnome-tweaks

./tailscale.sh
