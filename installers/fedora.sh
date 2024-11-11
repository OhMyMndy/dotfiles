#!/usr/bin/env bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

sudo dnf install -y git curl zsh podman-docker

# TODO: only if we have gnome installed
# sudo dnf install -y gnome-tweaks


./tailscale.sh
