#!/usr/bin/env bash

sudo dnf install -y git curl zsh podman-docker

# TODO: only if we have gnome installed
# sudo dnf install -y gnome-tweaks


if ! command -v tailscale &>/dev/null; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi
