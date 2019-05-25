#!/usr/bin/env bash


if [ $UID -eq 0 ]; then
	echo "Run this script as non root user please..."
	exit 99
fi


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set -e
source "$DIR/../../.functions"
set +e


function install_deb_from_url() {
	url="$1"
	tmp="$(mktemp)"
	curl -L "$url" >> "$tmp"
	sudo dpkg -i "$tmp"
}


function setup() {
	upgrade
	general
	locale
	settings
}

function green_bold() {
	echo "$(tput setaf 2)$*$(tput sgr0)"
	echo ''
}

function general() {
	green_bold Installing vim git byobu tmux
	sudo apt install vim-gtk3 git byobu tmux iotop htop zsh nmap tree -y

	green_bold Installing shutter parcellite
	sudo apt install shutter parcellite thunar redshift-gtk xfce4-terminal kdeconnect chromium-browser seahorse mate-calc -y

	sudo apt install vlc mpv sysfsutils sysstat openvpn network-manager-openvpn network-manager-openvpn-gnome remmina hfsprogs parallel cdck ruby -y
	sudo apt install xsel xclip samba arc-theme flatpak -y
	sudo apt install openssh-server -y
	sudo apt install cifs-utils exfat-fuse exfat-utils -y
	# pdf
	sudo apt install zathura 'zathura*' evince -y
	if ! which ulauncher >/dev/null 2>&1
	then
		sudo add-apt-repository ppa:agornostal/ulauncher -y
		sudo apt update
		sudo apt install ulauncher -y
		# fix dependencies if necessary
		sudo apt install -y -f
	fi

	if ! which bat >/dev/null 2>&1
	then
		install_deb_from_url https://github.com/sharkdp/bat/releases/download/v0.11.0/bat_0.11.0_amd64.deb
	fi

	if ! which fd >/dev/null 2>&1
	then
		install_deb_from_url https://github.com/sharkdp/fd/releases/download/v7.3.0/fd_7.3.0_amd64.deb
	fi

	if ! apt -qq list papirus-icon-theme 2>/dev/null| grep -i -q installed
	then
		sudo add-apt-repository ppa:papirus/papirus -y
		sudo apt update
		sudo apt install papirus-icon-theme -y
	fi
	bash "$DIR/apps/oh-my-zsh.sh"

	# Fix for snaps with ZSH
	LINE="emulate sh -c 'source /etc/profile'"
	FILE=/etc/zsh/zprofile
	grep -qF -- "$LINE" "$FILE" || echo "$LINE" | sudo tee "$FILE"


	if ! which fzf >/dev/null 2>&1
	then
		git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
		yes | ~/.fzf/install
	fi

	sudo chsh -s "$(which zsh)" mandy
	sudo snap install ripgrep --classic
	sudo snap install nextcloud-client --classic
	sudo snap connect nextcloud-client:password-manager-service

	yes | sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	sudo flatpak install flathub com.github.wwmm.pulseeffects -y
}


function groups() {
	sudo groupadd docker
	sudo groupadd vboxusers
	sudo usermod -aG docker mandy

	sudo usermod -aG disk mandy
	sudo usermod -aG cdrom mandy
	sudo usermod -aG vboxusers mandy
	sudo usermod -aG sudo mandy
	sudo usermod -aG sambashare mandy

}

function fonts() {
	installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/SourceCodePro.zip SourceCodeProNerdFont
	installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FantasqueSansMono.zip FantasqueSansMono 
	installFontsFromZip https://github.com/IBM/plex/releases/download/v1.4.1/OpenType.zip "IBM Plex" 
	xfconf-query -c xsettings -p /Gtk/FontName -s "IBM Plex Sans Text 9"
	xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "FantasqueSansMono Nerd Font Mono 10"
	xfconf-query -c xsettings -p /Gtk/DecorationLayout -s "menu:minimize,maximize,close"
	
	if [ "$fontsAdded" -eq 1 ]; then
		fc-cache -f -v
	fi
}


function settings() {
	if which xfconf-query >/dev/null 2>&1
	then
		# Execute executables in Thunar instead of editing them on double click: https://bbs.archlinux.org/viewtopic.php?id=194464
		xfconf-query --channel thunar --property /misc-exec-shell-scripts-by-default --create --type bool --set true

		xfconf-query -c xsettings -p /Net/ThemeName -s Adwaita
		xfconf-query -c xfwm4 -p /general/theme -s Adwaita
		xfconf-query -c xfwm4 -p /general/title_font -s "IBM Plex Sans Text 9"
	fi
}


function locale() {
	# Locale
	sudo locale-gen nl_BE
	sudo locale-gen nl_BE.UTF-8
	sudo locale-gen en_GB
	sudo locale-gen en_GB.UTF-8
	sudo locale-gen en_US
	sudo locale-gen en_US.UTF-8
	sudo update-locale

	sudo update-locale \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_CTYPE=nl_BE.UTF-8 \
	LC_NUMERIC=nl_BE.UTF-8 \
	LC_TIME=nl_BE.UTF-8 \
	LC_COLLATE=C \
	LC_MONETARY=nl_BE.UTF-8 \
	LC_MESSAGES=en_US.UTF-8 \
	LC_PAPER=nl_BE.UTF-8 \
	LC_NAME=nl_BE.UTF-8 \
	LC_ADDRESS=nl_BE.UTF-8 \
	LC_TELEPHONE=nl_BE.UTF-8 \
	LC_MEASUREMENT=nl_BE.UTF-8 \
	LC_IDENTIFICATION=nl_BE.UTF-8


}


function i3() {
	if [ ! -f /etc/apt/sources.list.d/sur5r-i3.list ];
	then
		cd /tmp
		/usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2019.02.01_all.deb keyring.deb SHA256:176af52de1a976f103f9809920d80d02411ac5e763f695327de9fa6aff23f416
		sudo dpkg -i ./keyring.deb
		echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
		sudo apt update
	fi
	sudo apt install udiskie compton dunst nitrogen feh xfce4-panel pcmanfm spacefm dunst rofi engrampa ssh-askpass-gnome -y
	sudo apt install -y "i3" i3blocks i3lock
	sudo apt install -y dmenu rofi
}


function openbox() {
	i3
	sudo apt install -y "openbox" obconf lxappearance xfce4-panel
}

function usb_ssd() {
	# Add usb3 SSD as usb-device instead of uas
	if [ ! -f /etc/modprobe.d/usb-storage.conf ]; then
		echo "options usb-storage quirks=174c:55aa:u" | sudo tee /etc/modprobe.d/usb-storage.conf
		sudo update-initramfs -u
	fi
}


function upgrade() {
	sudo apt update; sudo apt "upgrade" -y
	sudo apt install linux-headers-$(uname -r) dkms -y
	sudo /sbin/vboxconfig
	sudo apt autoremove -y
}


function media() {
	# Media things, disk burn software
	sudo apt install -y digikam k3b
	# Permissions for ripping cds
	sudo chmod 4711 /usr/bin/wodim; sudo chmod 4711 /usr/bin/cdrdao
}


function kde() {
	sudo apt install kronometer ktimer -y
	sudo apt install -y ark 
	sudo apt remove -y konsole akonadi korganizer kaddressbook kmail kjots kalarm kmail amarok
	# @todo remove kde pim etc
}

function uninstall_kde() {
	# @todo gwenview ?
	sudo apt remove -y ark okular '*kwallet*' kdevelop kate kwrite kronometer ktimer
	sudo apt autoremove -y
}

function privacy() {
	sudo apt install torbrowser-launcher -y
	# @todo add expressvpn / purevpn
	install_deb_from_url "https://s3.amazonaws.com/purevpn-dialer-assets/linux/app/purevpn_1.2.2_amd64.deb"
}


function macbook() {
	# Realtek drivers for MacBook
	sudo apt install firmware-b43-installer -y
}


function etcher() {
	echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
	sudo apt-get update
	sudo apt-get install balena-etcher-electron -y
}


function albert() {
	if ! which albert >/dev/null 2>&1
	then
		cd /tmp || exit 2
		wget -nv -O Release.key https://build.opensuse.org/projects/home:manuelschneid3r/public_key
		sudo apt-key add - < Release.key
		sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_18.10/ /' > /etc/apt/sources.list.d/home:manuelschneid3r.list"
		sudo apt-get update
		sudo apt install "albert" -y
		rm Release.key
	fi
}


function qt_dev() {
	# Qt development
	sudo apt install kdevelop qt5-default build-essential mesa-common-dev libglu1-mesa-dev -y
}


function dev() {
	sudo apt install shellcheck -y
	sudo snap install code --classic
	bash "$DIR/code.sh"
}


function php() {
	sudo apt install wkhtmltopdf php-cli php-xml php-mbstring php-curl php-zip php-pdo-sqlite php-intl -y
	sudo snap install phpstorm --classic
}


function docker() {
	sudo apt-get install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg2 \
		software-properties-common

	if ! which docker >/dev/null 2>&1
	then
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
		sudo apt-key fingerprint 0EBFCD88
		sudo add-apt-repository \
			"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
			$(lsb_release -cs) \
			stable"
		sudo apt-get update
		sudo apt-get install -y docker-ce
		sudo usermod -aG "docker" "$(whoami)"  
	fi

	if ! which docker-compose >/dev/null 2>&1
	then
		sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
		sudo chmod +x /usr/local/bin/docker-compose
	fi

	if which podman >/dev/null 2>&1
	then
		# Podman
		sudo apt update
		sudo apt -y install software-properties-common
		sudo add-apt-repository -y ppa:projectatomic/ppa
		sudo apt install podman -y
	fi
}

function polybar() {
	sudo apt install -y build-essential git cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev
	sudo apt install -y libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev

	cd /tmp
	git clone https://github.com/jaagr/polybar.git
	cd polybar && ./build.sh --all-features --gcc --install-config --auto
}


for i in "$@"
do
	function="${i//\-/}"
	echo "Executing $function"
	$function
done
