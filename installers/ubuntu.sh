#!/usr/bin/env bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

sudo apt-get update

# Python Build
sudo apt update
sudo apt install build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev curl git \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y

sudo apt-get install apt-file -y

# XDG utils is needed for gcloud for example
sudo apt-get install -y vim git curl zsh flatpak build-essential \
  xdg-utils flatpak-xdg-utils unzip python3-pip python3-venv composer

sudo snap remove firefox
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

sudo flatpak install flathub org.mozilla.firefox -y
#
# dependencies for building Python
sudo apt-get install -y build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev curl git \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
# TODO: only if we have gnome installed
# sudo apt-get install -y gnome-tweaks

./tailscale.sh
