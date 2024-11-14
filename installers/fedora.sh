#!/usr/bin/env bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

sudo dnf install -y vim git curl zsh flatpak @development-tools
sudo dnf remove firefox -y

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install flathub org.mozilla.firefox -y

# TODO: only if we have gnome installed
# sudo dnf install -y gnome-tweaks recoll

./tailscale.sh
