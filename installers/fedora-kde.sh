#!/usr/bin/env bash

# KDE configuration


if [ $UID -eq 0 ]; then
    echo "Run this script as non root user please..."
    exit 99
fi

# Albert
sudo rpm --import https://build.opensuse.org/projects/home:manuelschneid3r/public_key
sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/home:manuelschneid3r/Fedora_28/home:manuelschneid3r.repo



# sudo dnf install -y  VirtualBox-guest-additions
sudo dnf install -y @base-x @standard lightdm mesa-libEGL latte-dock breeze-gtk curl wget tar unzip htop openvpn albert
sudo dnf install -y @kde kde-connect krdc ark breeze-gtk


sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install gvfs-smb vlc tmux byobu google-roboto-fonts 'google-droid-*-fonts' -y


sudo dnf install fedora-workstation-repositories -y
sudo dnf config-manager --set-enabled google-chrome
sudo dnf install google-chrome-stable -y

sudo systemctl enable lightdm
sudo systemctl set-default graphical.target

wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/install.sh | sh
