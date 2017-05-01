#!/usr/bin/env bash


if ! grep  'archlinuxfr' /etc/pacman.conf ; then
   cat <<'EOL' | sudo tee -a /etc/pacman.conf

[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
EOL
fi

sudo pacman -Syu yaourt
yaourt -Syu
yaourt -S git
yaourt -S tig
yaourt -S vim


cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete.otf


yaourt -S i3-gaps
yaourt -S polybar
yaourt -S rofi
yaourt -S zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

yaourt -S ttf-chromeos-fonts
yaourt -S nerd-fonts-source-code-pro
yaourt -S parcellite
yaourt -S redshift
yaourt -S chromium
yaourt -S lightdm
yaourt -S gtk-engine-murrine
yaourt -S autokey-py3
yaourt -S openssh
cat /dev/zero | ssh-keygen -b 2048 -t rsa
sudo systemctl enable sshd
sudo systemctl start sshd


yaourt -S mopidy
yaourt -S mpd
yaourt -S ncmpcpp

yaourt -S dunst
yaourt -Sy xorg
yaourt -S lightdm-gtk-greeter
yaourt -S terminator
yaourt -S byobu
yaourt -S network-manager-applet
yaourt -S thunar
yaourt -S ranger
yaourt -S super-flat-remix-icon-theme 
yaourt -S lxappearance

sudo systemctl enable lightdm

yaourt -S docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -a -g docker $(whoami)

yaourt -S ntpd
sudo systemctl enable ntp
sudo timedatectl set-ntp yes

yaourt -S udisks2
sudo systemctl enable udisks2
sudo systemctl start udisks2

yaourt -S udiskie
yaourt -S exfat-utils

yaourt -S nmap
yaourt -S accountsservice
yaourt -S xorg-xauth



## Install zfs

## I had to manually change the kernel version in zfs-linux and it's dependencies
# yaourt -S zfs-linux

# sudo systemctl enable zfs-import-cache.service
# sudo systemctl enable zfs-mount.service
# sudo systemctl enable zfs.target

## Make sure to always override if necessary
# sudo sed -i -E 's|ExecStart.*$|ExecStart=/usr/bin/zfs mount -O -a|g' /usr/lib/systemd/system/zfs-mount.service



export MAKEPKG="makepkg --skipinteg"
yaourt -S vlc qt4
yaourt -S pulseaudio


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
