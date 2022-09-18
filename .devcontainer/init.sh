#!/usr/bin/env bash


./install.sh

sudo sed -i -E 's/#(user_allow_other)/\1/' /etc/fuse.conf

if ! mountpoint -q ~/docker-volumes; then
  mkdir -p ~/docker-volumes
  bindfs --force-user="$(id -u)" --force-group="$(id -g)" ~/docker-volumes ~/docker-volumes
fi
