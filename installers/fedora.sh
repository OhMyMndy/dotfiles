#!/usr/bin/env bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

# XDG utils is needed for gcloud for example
sudo dnf install -y vim git curl zsh flatpak @development-tools \
  unzip xdg-utils flatpak-xdg-utils python3-pip python3-virtualenv composer

sudo dnf remove firefox -y

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install flathub org.mozilla.firefox -y

# dependencies for building Python
sudo dnf install -y zlib-devel bzip2 bzip2-devel readline-devel \
  sqlite-devel openssl-devel xz xz-devel libffi-devel tk-devel

# build with asdf:
# asdf install python $(asdf list all python | grep '^3.12' | tail -1)

# TODO: only if we have gnome installed
# sudo dnf install -y gnome-tweaks recoll

./tailscale.sh
