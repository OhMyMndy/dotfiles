#!/usr/bin/env bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

# Podman and Docker
sudo dnf install moby-engine docker-compose podman podman-compose -y
sudo usermod -aG docker $USER

# LDAP
sudo dnf install -y sssd sssd-ldap oddjob-mkhomedir

# Hardening and benchmarking tools
sudo dnf install -y aide sysstat bonnie++ fs_mark
sudo systemctl enable --now sysstat

sudo dnf install -y qemu-user-static qemu-system-x86
sudo dnf install pipx -y

# XDG utils is needed for gcloud for example
sudo dnf install -y vim git curl zsh flatpak @development-tools \
  unzip xdg-utils flatpak-xdg-utils python3-pip python3-virtualenv composer

sudo dnf remove firefox -y

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
if arch != "aarch64"; then
  sudo flatpak install flathub org.mozilla.firefox -y
fi

# dependencies for building Python
sudo dnf install -y zlib-devel bzip2 bzip2-devel readline-devel \
  sqlite-devel openssl-devel xz xz-devel libffi-devel tk-devel

# Virtual machines
# sudo dnf install virt-manager libvirt-nss -y && sudo authselect enable-feature with-libvirt

# build with asdf:
# asdf install python $(asdf list all python | grep '^3.12' | tail -1)

# TODO: only if we have gnome installed
# sudo dnf install -y gnome-tweaks recoll

# TODO: get version number from `nix-search osquery` and download that rpm version
# osqueryd cannot be installed with home-manager
# SEE: https://osquery.readthedocs.io/en/stable/introduction/using-osqueryd/
# sudo rpm --install https://pkg.osquery.io/rpm/osquery-5.14.1-1.linux.x86_64.rpm

# ./tailscale.sh
