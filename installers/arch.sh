#!/usr/bin/env bash

if [[ $EUID -eq 0 ]]; then
  echo "This script must NOT be run as root" 1>&2
  exit 1
fi

set -e

install() {
    echo "Installing '$@'"
    yaourt --needed -S --noconfirm $@
}
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
install gtk-engine-murrine polybar-git ttf-roboto xcursor-dmz compton


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
install pcmanfm ranger file-roller evince


# Hardcode-tray + dependencies
install hardcode-tray sni-qt-patched-git

# Monitoring
install lm_sensors hardinfo

install coreutils

# Browsers
install chromium

# Chat applications
install rambox

# Editors
install vim intellij-idea-ce phpstorm-jre

# Graphic tools
install shutter

# Git tools
install tig


# Interpreters / compilers
install ruby


# Network/system utilities
install nmap ncdu bind-tools


# Development utilities
install meld node
install archiso
install synergy

# At
install at
sudo systemctl enable atd
sudo systemctl start atd


# Udiskie + disk utils
install udisks2 udiskie exfat-utils



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
install pulseaudio libmpdclient  mpd mpc ncmpcpp shntool mac alsa-utils alsamixer vis
install pavucontrol
install community/mac flacon community/cuetools

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


# Virtualization
install virtualbox qemu kvm
sudo adduser $USER vboxuser


###############
# Video
###############
export MAKEPKG="makepkg --skipinteg"
install mpv ffmpeg youtube-dl



sudo easy_install3 pip
sudo pip3 install ReText
sudo pip3 install thefuck
sudo pip3 install beets pylast requests
sudo pip3 install cheat
sudo pip3 install powerline-status

sudo gem install teamocil


sudo npm install -g gtop vtop yarn dockly vue-cli
# todo purevpn, newshosting, torrent, inkdrop,yaourt



# Install go
curl -o /tmp/go.tgz https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz
cd /usr/local
sudo tar xzvf /tmp/go.tgz

mkdir -p ~/.go/bin/
curl https://glide.sh/get | sh

install fortune-mod pdftotext rmlint
