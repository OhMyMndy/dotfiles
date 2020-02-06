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
    #apt-get install -qq -y x11-repo

    #apt-get update -qq && apt-get install -qq -y openbox pypanel xorg-xsetroot tigervnc

    apt-get install -qq -y dnsutils neovim tracepath rclone libnotify iproute2

    apt-get install -qq -y openssh zsh git vim tmux wget curl ruby termux-api jq binutils openssl-tool proot
    yes | apt-get upgrade -qq -y
}  >/dev/null

echo "deb [trusted=yes] https://yadominjinta.github.io/files/ termux extras" > "$PREFIX/etc/apt/sources.list.d/atilo.list"
pkg in atilo


if ! exists startubuntults ; then
    atilo install ubuntults
    sed -Ei 's/(^export PROOT_NO_SECCOMP.*)/#\1/g' "$(command -v startubuntults)"
    startubuntults "apt update -qq; apt upgrade -y -qq; apt install -y -qq git"
fi


if ! exists startubuntu ; then
    atilo install ubuntu
    sed -Ei 's/(^export PROOT_NO_SECCOMP.*)/#\1/g' "$(command -v startubuntu)"
    startubuntults "apt update -qq; apt upgrade -y -qq; apt install -y -qq git"
fi
