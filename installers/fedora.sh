#!/usr/bin/env bash

sudo dnf update -y
sudo dnf install git i3 xterm zsh google-roboto-fonts redshift htop -y
sudo dnf -y install gcc automake make kernel-headers kernel-devel perl

sudo dnf copr enable tomwishaupt/polybar -y
sudo dnf install polybar -y


# install polybar
sudo dnf install -y cmake @development-tools gcc-c++ i3-ipc jsoncpp-devel alsa-lib-devel wireless-tools-devel libmpdclient-devel libcurl-devel cairo-devel xcb-proto xcb-util-devel xcb-util-wm-devel xcb-util-image-devel

rm -rf /tmp/polybar
git clone --recursive https://github.com/jaagr/polybar /tmp/polybar
cd /tmp/polybar

pkill polybar

./build.sh -f
# end install Polybar


read "Insert guest addition CD, then press a key to continue..."
sudo /run/media/user/VBox*/VBoxLinuxAdditions.run
