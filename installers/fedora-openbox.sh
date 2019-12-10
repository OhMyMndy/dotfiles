#!/usr/bin/env bash


if [ $UID -eq 0 ]; then
    echo "Run this script as non root user please..."
    exit 99
fi

# sudo dnf install -y  VirtualBox-guest-additions
sudo dnf install -y @base-x openbox mesa-libEGL opbconf obmenu numix-gtk-theme xfce4-terminal lxappearance pcmanfm openvpn @networkmanager-submodules NetworkManager-openvpn-gnome network-manager-applet

cat <<'EOL' | tee ~/.profile
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi

EOL

mkdir -p ~/.config/openbox/
cat <<'EOL' | tee ~/.config/openbox/autostart
tint2 &
nm-applet &
EOL


cat <<'EOL' | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin user --noclear %I 38400 linux
EOL

sudo systemctl enable getty@tty1

sudo dnf install -y https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm
sudo dnf install -y http://download.nomachine.com/download/6.1/Linux/nomachine_6.1.6_9_x86_64.rpm


sudo systemctl set-default graphical.target

# https://unix.stackexchange.com/questions/401759/automatically-login-on-debian-9-2-1-command-line
