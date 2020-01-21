#!/usr/bin/env bash

trap "exit" INT
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

apt update
apt install -y x11-repo

apt update && apt install -y openbox pypanel xorg-xsetroot tigervnc

apt install -y dnsutils neovim tracepath rclone sudo

apt install -y openssh zsh git vim tmux wget curl termux-api
