#!/usr/bin/env bash

set -e

source $HOME/.functions

if ! grep 'QT_STYLE_OVERRIDE=gtk' /etc/environment ; then
    cat <<'EOL' | sudo tee -a /etc/environment
export QT_STYLE_OVERRIDE=gtk
EOL
fi

if ! grep  'archlinuxfr' /etc/pacman.conf ; then
   cat <<'EOL' | sudo tee -a /etc/pacman.conf

[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
EOL
fi

if [ ! -f "~/.yaourtrc" ];
then
cat <<'EOL' | sudo tee -a ~/.yaourtrc
NOCONFIRM=1
BUILD_NOCONFIRM=1
EDITFILES=0
EOL
fi

# Update packages

# Update gpg keys
# sudo pacman -Sy archlinux-keyring
#sudo pacman-key --refresh-keys


yaourt -Swy # update index, do not install all updates

###############
# Desktop Environment / Defaults
###############

# WM + greeter
install base-devel git plymouth xorg-xauth accountsservice lightdm lightdm-gtk-greeter
yes | yaourt -R i3-wm | true


# Interface
install i3-gaps-git
install gtk-engine-murrine polybar-git ttf-roboto xcursor-dmz


# Essentials
install unzip openssh zsh htop


# Interface dependencies
install arandr lxappearance parcellite
install rofi redshift dunst byobu network-manager-applet
install i3lock feh
install xbanish xsel xclip paper-gtk-theme-git papirus-icon-theme
install yad peco gsimplecal
install volti w3m

# File managers
install pcmanfm ranger file-roller


# Hardcode-tray + dependencies
install hardcode-tray sni-qt-patched-git


# Browsers
install chromium

# Chat applications
install aur/slack-desktop

# Editors
install vim intellij-idea-ce


# Git tools
install tig


# Interpreters / compilers
install ruby


# Network/system utilities
install nmap ncdu


# Development utilities
install meld


# At
install at
sudo systemctl enable atd
sudo systemctl start atd


# Udiskie + disk utils
install udisks2 udiskie exfat-utils

# Developer tools
install node

# Lightdm
sed -E 's/.*greeter-session=.*/greeter-session=lightdm-gtk-greeter/g' /etc/lightdm/lightdm.conf
sudo systemctl enable lightdm
sudo systemctl start lightdm


# Udisks2
sudo systemctl enable udisks2
sudo systemctl start udisks2


# SSH
cat /dev/zero | ssh-keygen -b 2048 -t rsa || true
sudo systemctl enable sshd
sudo systemctl start sshd




###############
# Music
###############
# mopidy
install pulseaudio libmpdclient  mpd ncmpcpp shntool mac

cat <<'EOL' | sudo tee /etc/systemd/system/pulseaudio.service
[Unit]
Description=PulseAudio Daemon

[Install]
WantedBy=multi-user.target

[Service]
Type=simple
PrivateTmp=true
ExecStart=/usr/bin/pulseaudio --system --realtime --disallow-exit --no-cpu-limit
EOL

sudo systemctl enable pulseaudio
sudo systemctl start pulseaudio


###############
# Docker
###############
install docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -a -G docker $(whoami)

# date
sudo systemctl enable ntp
sudo timedatectl set-ntp yes

## I had to manually change the kernel version in zfs-linux and it's dependencies
# yaourt -S zfs-linux

# sudo systemctl enable zfs-import-cache.service
# sudo systemctl enable zfs-mount.service
# sudo systemctl enable zfs.target

## Make sure to always override if necessary
# sudo sed -i -E 's|ExecStart.*$|ExecStart=/usr/bin/zfs mount -O -a|g' /usr/lib/systemd/system/zfs-mount.service


###############
# Video
###############
export MAKEPKG="makepkg --skipinteg"
install vlc qt4




sudo easy_install3 pip
sudo pip3 install ReText
sudo pip3 install thefuck
sudo pip3 install beets pylast requests
sudo pip3 install cheat

sudo gem install teamocil


sudo npm install -g gtop vtop yarn dockly

# todo purevpn, newshosting, torrent, inkdrop,yaourt
