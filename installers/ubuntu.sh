#!/usr/bin/env bash


if [ $UID -eq 0 ]; then
    echo "Run this script as non root user please..."
    exit 99
fi


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


function install_deb_from_url() {
    url="$1"
    tmp="$(tempfile)"
    curl "$url" >> "$tmp"
    sudo dpkg -i "$tmp"
}


# Add usb3 SSD as usb-device instead of uas
echo "options usb-storage quirks=174c:55aa:u" | sudo tee /etc/modprobe.d/usb-storage.conf
sudo update-initramfs -u

sudo apt update

sudo apt install vim git xfce4-terminal byobu tmux iotop htop zsh kcalc digikam cifs-utils libdbusmenu-gtk* vlc nmap sysfsutils sysstat \
                 network-manager-openvpn kate remmina xdotool gimp kmymoney konversation -y

sudo apt install kronometer ktimer -y
sudo apt install xsel xclip -y
sudo apt install virt-manager virt-viewer -y

# Realtek drivers for MacBook
sudo apt install kate firmware-b43-installer -y

sudo apt upgrade -y
sudo apt autoremove -y


sudo chsh -s $(which zsh) mandy

sudo snap install intellij-idea-community --classic
sudo snap install sublime-text --classic



bash $DIR/oh-my-zsh.sh


# Fix for snaps with ZSH
LINE="emulate sh -c 'source /etc/profile'"
FILE=/etc/zsh/zprofile
grep -qF -- "$LINE" "$FILE" || echo "$LINE" | sudo tee "$FILE"



# install_deb_from_url "https://s3.amazonaws.com/purevpn-dialer-assets/linux/app/purevpn_1.2.2_amd64.deb"


# Albert
cd /tmp
wget -nv -O Release.key https://build.opensuse.org/projects/home:manuelschneid3r/public_key
sudo apt-key add - < Release.key
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_18.10/ /' > /etc/apt/sources.list.d/home:manuelschneid3r.list"
sudo apt-get update
sudo apt install albert -y
rm Release.key




# Locale
sudo locale-gen nl_BE
sudo locale-gen nl_BE.UTF-8
sudo locale-gen en_GB
sudo locale-gen en_GB.UTF-8
sudo locale-gen en_US
sudo locale-gen en_US.UTF-8
sudo update-locale
