#!/usr/bin/env bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

sudo apt-get update

sudo apt-get install apt-file -y

# XDG utils is needed for gcloud for example
sudo apt-get install -y vim git curl zsh flatpak build-essential \
  xdg-utils flatpak-xdg-utils unzip python3-pip python3-venv composer

sudo snap remove firefox
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

sudo flatpak install flathub org.mozilla.firefox -y

# TODO: only if we have gnome installed
# sudo apt-get install -y gnome-tweaks

./tailscale.sh
