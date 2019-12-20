#!/usr/bin/env bash

trap "exit" INT

apt update
apt install -y x11-repo

apt update && apt install -y openbox pypanel xorg-xsetroot tigervnc

apt install -y dnsutils vim git tmux tracepath
