#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y git curl zsh podman-docker

# TODO: only if we have gnome installed
# sudo apt-get install -y gnome-tweaks


./tailscale.sh


