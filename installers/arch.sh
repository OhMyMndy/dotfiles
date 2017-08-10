#!/usr/bin/env bash

set -e

install() {
    yaourt --needed -S $@
}

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

sudo pacman -Syu yaourt
yaourt -Syu

###############
# Desktop Environment / Defaults
###############
install base-devel git plymouth xorg-xauth accountsservice lightdm lightdm-gtk-greeter
yes | yaourt -R i3-wm
install gtk-engine-murrine i3-gaps polybar-git ttf-roboto
install ruby rofi zsh redshift openssh chromium xcursor-dmz gtk-theme-arc-git
# Hardcode-tray + dependencies
install hardcode-tray sni-qt-patched-git at # lib32-sni-qt-patched-git

sudo systemctl enable atd
sudo systemctl start atd

install dunst byobu network-manager-applet thunar ranger lxappearance parcellite udisks2 udiskie i3lock arandr
# Network/system utilities
install nmap meld  yad ncdu

# autokey-py3

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
# Development
###############
install tig vim


###############
# Music
###############
install pulseaudio libmpdclient mopidy mpd ncmpcpp shntool mac

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
# Settings
###############
sudo dconf write /org/gnome/desktop/interface/font-name "'Sans 10'"
sudo dconf write /org/gnome/desktop/interface/monospace-font-name "'DroidSansMonoForPowerline Nerd Font Book 9'"
sudo dconf write /org/gnome/desktop/interface/text-scaling-factor 1



sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions




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

sudo gem install teamocil


# todo purevpn, newshosting, torrent, inkdrop,yaourt