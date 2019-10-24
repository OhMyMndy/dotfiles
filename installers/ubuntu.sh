#!/usr/bin/env bash


if [ $UID -eq 0 ]; then
	echo "Run this script as non root user please..."
	exit 99
fi


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


function _install_deb_from_url() {
	url="$1"
	tmp="$(mktemp)"
	curl -L "$url" >> "$tmp"
	sudo dpkg -i "$tmp"
}


function setup() {
	upgrade
	#general
	minimal
	locale
	settings
	firewall
	dns
	albert
	autostart
	git_config
}

function _green_bold() {
	echo "$(tput setaf 2)$*$(tput sgr0)"
	echo ''
}

function minimal() {
	sudo add-apt-repository -y "deb http://archive.canonical.com/ $(lsb_release -sc) partner"

	sudo apt update -y

	# minimal
	sudo apt install -y file coreutils findutils vlock nnn ack sed tree grep silversearcher-ag
	sudo apt install -y python-pip python3-pip
	# Misc
	sudo apt install -y git tig gitg zsh less curl rename rsync openssh-server most multitail trash-cli libsecret-tools parallel ruby ntp vim fonts-noto fonts-roboto

	# Terminal multiplexing
	sudo apt install -y byobu tmux

	# System monitoring
	sudo apt install -y iotop htop nload glances

	# Networking tools
	sudo apt install -y nmap iputils-ping dnsutils telnet-ssl mtr-tiny traceroute libnss3-tools netdiscover
	# smbmap, only available in disco+

	# Cron
	sudo apt install -y cron cronic

	# Mailing
	sudo apt install -y msmtp-mta thunderbird

	# Cli browser with inline images
	sudo apt install -y w3m w3m-img

	# Apt tools
	sudo apt install -y apt-file wajig

	# Esential X tools
	# kdeconnect
	sudo apt install -y shutter parcellite redshift-gtk xfce4-terminal xfce4-genmon-plugin chromium-browser seahorse galculator orage ristretto \
		xsel xclip arandr wmctrl xscreensaver flatpak

	# File management and disk plugins
	sudo apt install -y cifs-utils exfat-fuse exfat-utils samba hfsprogs cdck ncdu mtp-tools

	# File management and disk plugins X
	sudo apt install -y thunar pcmanfm gnome-disk-utility

	# Remote desktop
	sudo apt install -y remmina vinagre xephyr

	# Themes
	sudo apt install -y arc-theme bluebird-gtk-theme

	# Language and spell check
	sudo apt install -y aspell

	git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

	# Editors
	sudo apt install -y geany vim-gtk3 emacs

	# Archiving
	sudo apt install -y engrampa unzip unrar p7zip-full ecm

	# Window managing
	# quicktile dependencies
	sudo apt install -y python python-gtk2 python-xlib python-dbus python-setuptools libpango-1.0
	cd /tmp && wget http://ftp.nl.debian.org/debian/pool/main/g/gnome-python-desktop/python-wnck_2.32.0+dfsg-3_amd64.deb
	sudo dpkg -i python-wnck_2.32.0+dfsg-3_amd64.deb


	sudo pip2 install https://github.com/ssokolow/quicktile/archive/master.zip

 	sudo pip3 install git+https://github.com/jeffkaufman/icdiff.git

	# @todo set the gemrc files in place before running gem install
	#gem install teamocil
	albert
	bash "$DIR/apps/oh-my-zsh.sh"
	# Fix for snaps with ZSH
	LINE="emulate sh -c 'source /etc/profile'"
	FILE=/etc/zsh/zprofile
	grep -qF -- "$LINE" "$FILE" || echo "$LINE" | sudo tee "$FILE"


	sudo snap install code --classic
	bash "$DIR/apps/code.sh"

	if ! which fzf >/dev/null 2>&1
	then
		git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
		yes | ~/.fzf/install
	fi

	sudo chsh -s "$(which zsh)" mandy
}

function general() {
	set -e
	sudo apt update -y
	

	# Build tools
	sudo apt install -y build-essential dkms software-properties-common

	# System utils
	sudo apt install -y sysfsutils sysstat qdirstat 

	# Media
	sudo apt install -y vlc quodlibet imagemagick

	# Vpn and network manager
	sudo apt install -y openvpn network-manager-openvpn network-manager-openvpn-gnome 

	sudo apt install -y moka-icon-theme

	# PDF
	sudo apt install -y zathura 'zathura*' atril

	if [ ! -f /usr/NX/bin/nxplayer ]
	then
		_install_deb_from_url "$(curl https://www.nomachine.com/download/download\&id\=6 2>/dev/null | grep -E -o "http.*download.*deb")"
	fi

	if ! which nextcloud-client &>/dev/null
	then
		sudo add-apt-repository ppa:nextcloud-devs/client -y
		sudo apt update
		sudo apt install -y nextcloud-client
	fi

	if ! which bat &>/dev/null
	then
		_install_deb_from_url https://github.com/sharkdp/bat/releases/download/v0.11.0/bat_0.11.0_amd64.deb
	fi

	if ! which alacritty &>/dev/null
	then
		sudo add-apt-repository ppa:mmstick76/alacritty -y
		sudo apt update
		sudo apt install -y alacritty
	fi

	if ! which fd &>/dev/null
	then
		_install_deb_from_url https://github.com/sharkdp/fd/releases/download/v7.3.0/fd_7.3.0_amd64.deb
	fi

	if ! which x11docker &>/dev/null
	then
		curl -fsSL https://raw.githubusercontent.com/mviereck/x11docker/master/x11docker | sudo bash -s -- --update

	fi
		

	if ! which lazygit &>/dev/null
	then
		sudo add-apt-repository ppa:lazygit-team/release -y
		sudo apt-get update
		sudo apt-get install -y lazygit
	fi


	# if ! which indicator-kdeconnect &>/dev/null
	# then
	# 	yes | sudo add-apt-repository ppa:webupd8team/indicator-kdeconnect
	# 	sudo apt update
	# 	sudo apt install -y kdeconnect indicator-kdeconnect
	# fi

	if ! apt -qq list papirus-icon-theme 2>/dev/null | grep -i -q installed
	then
		sudo add-apt-repository ppa:papirus/papirus -y
		sudo apt update
		sudo apt install -y papirus-icon-theme
	fi
	
	sudo snap install ripgrep --classic


	yes | flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo --user
	flatpak install flathub com.github.wwmm.pulseeffects -y --user


	sudo apt remove -y parole mpv 'pidgin*'

	sudo pip3 install thefuck
	sudo pip3 install numpy
	sudo pip3 install csvkit
	sudo pip3 install httpie
	sudo python3 -m pip install docnado --upgrade

	set +e
}


function groups() {
	sudo groupadd docker
	sudo groupadd vboxusers
	sudo groupadd mail
	sudo groupadd sambashare
	
	sudo usermod -aG docker mandy
	sudo usermod -aG mail mandy
	sudo usermod -aG disk mandy
	sudo usermod -aG cdrom mandy
	sudo usermod -aG vboxusers mandy
	sudo usermod -aG sudo mandy
	sudo usermod -aG sambashare mandy
	sudo usermod -aG netdev mandy
	sudo usermod -aG dialout mandy

}

function fonts() {
	installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/SourceCodePro.zip SourceCodeProNerdFont
	installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FantasqueSansMono.zip FantasqueSansMono 
	installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/DroidSansMono.zip DroidSansMono
	installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/DejaVuSansMono.zip DejaVuSansMono
	installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Iosevka.zip Iosevka
	installFontsFromZip https://github.com/IBM/plex/releases/download/v1.4.1/OpenType.zip "IBM Plex" 
	
	
	if [ "$fontsAdded" = 1 ]; then
		fc-cache -f -v
	fi
}


function settings() {
	if which xfconf-query &>/dev/null
	then
		# Execute executables in Thunar instead of editing them on double click: https://bbs.archlinux.org/viewtopic.php?id=194464
		xfconf-query --channel thunar --property /misc-exec-shell-scripts-by-default --create --type bool --set true


		xfconf-query -c xsettings -p /Gtk/FontName -s "Noto Sans Regular 10"
		# xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "FantasqueSansMono Nerd Font Mono 10"
		# xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "DroidSansMono Nerd Font 10"
		xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "Iosevka Nerd Font Mono 10"
		xfconf-query -c xsettings -p /Gtk/DecorationLayout -s "menu:minimize,maximize,close"
		
		xfconf-query -c xsettings -p /Gtk/ButtonImages -s true

		xfconf-query -c xsettings -p /Net/ThemeName -s Adwaita
		xfconf-query -c xfwm4 -p /general/theme -s Bluebird
		xfconf-query -c xfwm4 -p /general/title_font -s "Noto Sans Regular 10"
		xfconf-query -c xfwm4 -p /general/button_layout  -s "O|HMC"
		xfconf-query -c xfwm4 -p /general/cycle_preview -s false
		xfconf-query -c xfwm4 -p /general/mousewheel_rollup  -s false
		xfconf-query -c xfwm4 -p /general/workspace_names  -n -t string -t string -t string -t string -s "1" -s "2" -s "3" -s "4"
		xfconf-query -c xfwm4 -p /general/workspace_count -s 4


 		xfconf-query -c xfce4-session -p /compat/LaunchGNOME -s true
		xfconf-query -c xsettings -p /Net/IconThemeName -s Papirus-Light
	fi


	# X11 forwarding over SSH
	sudo sed -i -E 's|.*X11UseLocalhost.*|X11UseLocalhost no|g' /etc/ssh/sshd_config
	sudo sed -i -E 's|.*X11Forwarding.*|X11Forwarding yes|g' /etc/ssh/sshd_config
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

	sudo apt install -y udiskie compton nitrogen feh xfce4-panel pcmanfm spacefm rofi ssh-askpass-gnome
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
	sudo apt install "linux-headers-$(uname -r)" dkms -y
	sudo /sbin/vboxconfig
	sudo apt autoremove -y
}


function media() {
	# Media things, disk burn software
	sudo apt install -y digikam k3b # darktable
	# Permissions for ripping cds
	sudo chmod 4711 /usr/bin/wodim; 
	sudo chmod 4711 /usr/bin/cdrdao
}

function chat() {
	sudo snap install slack --classic
	sudo snap install discord --classic

}
function kde() {
	sudo apt install -y kronometer ktimer ark
	sudo apt remove -y konsole akonadi korganizer kaddressbook kmail kjots kalarm kmail amarok
	# @todo remove kde pim etc
}

function uninstall_kde() {
	# @todo gwenview ?
	sudo apt remove -y ark okular '*kwallet*' kdevelop kate kwrite kronometer ktimer
	sudo apt autoremove -y
}

function privacy() {
	# sudo apt install -y torbrowser-launcher
	# @todo add expressvpn
	_install_deb_from_url "https://s3.amazonaws.com/purevpn-dialer-assets/linux/app/purevpn_1.2.2_amd64.deb"
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
	if ! which albert &>/dev/null
	then
		. /etc/lsb-release   
		cd /tmp || exit 2
		wget -nv -O Release.key https://build.opensuse.org/projects/home:manuelschneid3r/public_key
		sudo apt-key add - < Release.key
		sudo sh -c "echo \"deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_$DISTRIB_RELEASE/ /\" > /etc/apt/sources.list.d/home:manuelschneid3r.list"
		sudo apt-get update
		sudo apt install "albert" -y
		rm Release.key
	fi
}


function qt_dev() {
	# Qt development
	sudo apt install -y kdevelop qt5-default build-essential mesa-common-dev libglu1-mesa-dev
}


function jupyter() {
	pip3 install jupyterlab
	npm config set prefix $HOME/.local
	npm install -g ijavascript && ijsinstall
	pip3 install bash_kernel && python3 -m bash_kernel.install
	pip3 install gnuplot_kernel && python3 -m gnuplot_kernel install --user
}

function dev() {
	sudo apt install -y shellcheck nodejs npm

	# Run typescript without compiling
 	sudo npm install -g ts-node
 	sudo npm install -g typescript


	if ! which circleci &>/dev/null
	then
		curl -fLSs https://circle.ci/cli | sudo bash
	fi
	# Gnu global
	sudo apt install -y global ctags
}


function php() {
	sudo apt install -y wkhtmltopdf php-cli php-xml php-mbstring php-curl php-zip php-pdo-sqlite php-intl php-zmq
	sudo apt install -y kcachegrind
	sudo snap install phpstorm --classic
	pip3 install mycli
	pip3 install pre-commit

	if ! which composer &>/dev/null
	then
		curl -sS https://getcomposer.org/installer | $(which php) && sudo mv composer.phar /usr/local/bin/composer
	fi
	curl -sS https://litipk.github.io/Jupyter-PHP-Installer/dist/jupyter-php-installer.phar > /tmp/jupyter.php; $(which php) /tmp/jupyter.php install; rm /tmp/jupyter.php
}


function docker() {
	sudo apt-get install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg2 \
		software-properties-common

	if ! which docker &>/dev/null
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

	if ! which docker-compose &>/dev/null
	then
		sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
		sudo chmod +x /usr/local/bin/docker-compose
	fi

	# if which podman &>/dev/null
	# then
	# 	# Podman
	# 	sudo apt update
	# 	sudo apt -y install software-properties-common
	# 	sudo add-apt-repository -y ppa:projectatomic/ppa
	# 	sudo apt install podman -y
	# fi

	cd /tmp
	curl -L https://github.com/jesseduffield/lazydocker/releases/download/v0.7.1/lazydocker_0.7.1_Linux_x86_64.tar.gz > lazydocker.tgz
	tar xzf lazydocker.tgz
	sudo install lazydocker /usr/local/bin/
}

function polybar() {
	sudo apt install -y build-essential git cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev
	sudo apt install -y libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev

	cd /tmp
	git clone https://github.com/jaagr/polybar.git
	cd polybar && ./build.sh --all-features --gcc --install-config --auto
}


function dns() {
	if [ ! -f /etc/NetworkManager/conf.d/00-use-dnsmasq.conf ]; then
		sudo tee /etc/NetworkManager/conf.d/00-use-dnsmasq.conf << EOL
# This enabled the dnsmasq plugin.
[main]
dns=dnsmasq
EOL

		sudo tee /etc/NetworkManager/dnsmasq.d/00-home-mndy-be.conf << EOL
address=/home.mndy.be/192.168.10.120
addn-hosts=/etc/hosts
EOL

		# use network manager instead of systemd resolve resolv.conf
		sudo rm /etc/resolv.conf; sudo ln -s /var/run/NetworkManager/resolv.conf /etc/resolv.conf
		sudo systemctl restart NetworkManager
	fi
}

function sysctl() {
	# @todo add https://askubuntu.com/questions/23674/netbook-freezes-with-high-load-on-every-io-operation to sysctl if IO performance is a problem
	# @todo add to /etc/sysctl.conf
#fs.inotify.max_user_watches = 524288
#net.ipv4.ip_forward=1
#kernel.printk = 2 4 1 7
#vm.swappiness = 2
#vm.max_map_count=262144
	echo "todo"
}

function firewall() {
	sudo ufw enable
	yes | sudo ufw reset
	sudo ufw allow 22/udp
	sudo ufw allow 22/tcp

	sudo ufw allow 80/udp
	sudo ufw allow 443/udp
	sudo ufw allow 80/tcp
	sudo ufw allow 443/tcp

	# pulse over HTTP
	sudo ufw allow 8080/udp
	sudo ufw allow 8080/tcp

	# access local hosts through vpn
	sudo ip route add 192.168.10.0/24 dev $(ls /sys/class/net | grep "^en*" | head -1)  
}

function git_config() {
	git config --global submodule.recurse true
	git config --global user.name Mandy Schoep
	echo "Manually execute 'git config --global user.email <email>'"
}

function autostart() {
	mkdir -p ~/.config/autostart
	cp /usr/share/applications/albert.desktop ~/.config/autostart/
	cp /usr/share/applications/redshift-gtk.desktop ~/.config/autostart/
	cp /usr/share/applications/parcellite.desktop ~/.config/autostart/
	cp /usr/share/applications/nextcloud.desktop ~/.config/autostart/
}

set -e
source "$DIR/../.functions"
set +e

function _print_usage() {
	shopt -s extdebug
	IFS=$'\n'

	echo "Usage: $0 [options]"
	echo
	echo "Options:"
	echo

	for f in $(declare -F); do
		f="${f:11}"
		function_location="$(declare -f -F $f | cut -d' ' -f3)"
		if [[ "${f:0:1}" != "_" ]] &&  [[ "$function_location" == "$BASH_SOURCE" ]]; then
			echo "  --${f}"
		fi
	done
}


if [[ $# -eq 0 ]]; then
	_print_usage
else
	shopt -s extdebug
	for i in "$@"
	do
		function="${i//\-/}"
		starts_with_underscore=0
		if [[ "${i::1}" == '_' ]]; then
			starts_with_underscore=1
		fi
		if [[ "$function" == "help" ]]; then
			_print_usage
			exit 0
		fi
		function_location="$(declare -F $function | cut -d' ' -f3)"
		if [[ -n "$(declare -f -F $function)" ]] && [[ "$function_location" == "$BASH_SOURCE" ]] && [ $starts_with_underscore -eq 0 ]; then
			echo "Executing $function"
			$function
		else
			>&2 echo "Function with name \"$function\" not found!"
			>&2 echo
			_print_usage
			exit 2
		fi
	done
fi
