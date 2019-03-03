#!/usr/bin/env bash


if [ $UID -eq 0 ]; then
    echo "Run this script as non root user please..."
    exit 99
fi


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


function install_deb_from_url() {
    url="$1"
    tmp="$(mktemp)"
    curl "$url" >> "$tmp"
    sudo dpkg -i "$tmp"
}


# Add usb3 SSD as usb-device instead of uas
echo "options usb-storage quirks=174c:55aa:u" | sudo tee /etc/modprobe.d/usb-storage.conf
sudo update-initramfs -u

sudo apt update

sudo apt install vim git xfce4-terminal byobu tmux iotop htop zsh kcalc digikam cifs-utils libdbusmenu-gtk* vlc mpv nmap sysfsutils sysstat \
                 network-manager-openvpn kate remmina xdotool gimp kmymoney konversation hfsprogs qdirstat parallel cdck -y

sudo apt install kronometer ktimer -y
sudo apt install xsel xclip samba kdenetwork-filesharing -y
sudo apt install virt-manager virt-viewer openssh-server k3b calligra -y

sudo apt install exfat-fuse exfat-utils -y



# Tor browser
sudo apt install torbrowser-launcher -y


sudo chmod 4711 /usr/bin/wodim; sudo chmod 4711 /usr/bin/cdrdao

# Realtek drivers for MacBook
sudo apt install firmware-b43-installer -y

sudo apt upgrade -y
sudo apt autoremove -y


sudo chsh -s "$(which zsh)" mandy

sudo snap install intellij-idea-community --classic
sudo snap install sublime-text --classic

# Etcher
echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
sudo apt-get update
sudo apt-get install balena-etcher-electron -y


bash "$DIR/oh-my-zsh.sh"


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



# Qt development
sudo apt install kdevelop qt5-default build-essential mesa-common-dev libglu1-mesa-dev -y

# Development
sudo apt install shellcheck -y
sudo apt install wkhtmltopdf php-cli php-xml php-mbstring php-curl php-zip php-pdo-sqlite php-intl -y


# Docker
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo usermod -aG docker "$(whoami)"  


sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Locale
sudo locale-gen nl_BE
sudo locale-gen nl_BE.UTF-8
sudo locale-gen en_GB
sudo locale-gen en_GB.UTF-8
sudo locale-gen en_US
sudo locale-gen en_US.UTF-8
sudo update-locale
