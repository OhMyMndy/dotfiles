#!/usr/bin/env bash

set -eu
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR" || exit 1
# shellcheck source=../.base-script.sh
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../.base-script.sh"

if ! is_android; then
	echo "You are running on a non Android system"
	exit 101
fi

{
    apt-get update -qq
    apt-get install -qq -y x11-repo

    apt-get update -qq && apt-get install -qq -y openbox pypanel xorg-xsetroot tigervnc

    apt-get install -qq -y dnsutils neovim tracepath rclone

    apt-get install -qq -y openssh zsh git vim tmux wget curl termux-api jq binutils openssl-tool
    yes | apt-get upgrade -qq -y
}  >/dev/null
