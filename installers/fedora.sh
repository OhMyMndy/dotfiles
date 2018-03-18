#!/usr/bin/env bash

sudo dnf update -y
sudo dnf install git i3 xterm zsh google-roboto-fonts redshift htop rofi -y
sudo dnf install ruby dunst neofetch -y

sudo dnf copr enable yaroslav/i3desktop
sudo dnf install rofi -y

# install polybar
sudo dnf install -y cmake @development-tools gcc-c++ i3-ipc jsoncpp-devel pulseaudio-libs-devel alsa-lib-devel wireless-tools-devel libmpdclient-devel libcurl-devel cairo-devel xcb-proto xcb-util-devel xcb-util-wm-devel xcb-util-image-devel
sudo dnf install -y pulseaudio-libs-devel xcb-util-xrm-devel

rm -rf /tmp/polybar
git clone --recursive https://github.com/jaagr/polybar /tmp/polybar
cd /tmp/polybar
mkdir build
cd build
cmake ..
sudo make install
# end install Polybar
