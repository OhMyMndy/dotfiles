#!/usr/bin/env bash

# shellcheck disable=SC2230
# shellcheck disable=SC2155

export DEBIAN_FRONTEND=noninteractive

# to test this script: `docker run --rm -v "${PWD}:${PWD}:ro" -it "ubuntu-mandy:0.1-20.04" -c "$PWD/installers/ubuntu.sh --ulauncher"`

trap "exit" INT


if [ $UID -eq 0 ]; then
	echo "Run this script as non root user please..."
	exit 99
fi

fontsAdded=0

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(git rev-parse --show-toplevel)"

# shellcheck source=./xfce.sh
source "$DIR/xfce.sh"

function _install_deb_from_url() {
	local url="$1"
	local tmp="$(mktemp)"
	curl -L "$url" >> "$tmp"
	sudo -E dpkg -i "$tmp"
	sudo -E apt install -f -y
}

function _add_repo_or_install_deb() {
	local repo="$1"
	local package_name="$2"
	local optional_deb="$3"

	if ! which "$package_name" &>/dev/null; then
		sudo -E add-apt-repository "$repo" -y
		sudo -E apt-get update
		sudo -E apt install -y "$package_name"
	fi

	# still no package?? remove repo and install deb
	if ! which "$package_name" &>/dev/null; then
		sudo -E add-apt-repository --remove "$repo" -y
		if [[ $optional_deb != '' ]]; then
			_install_deb_from_url "$optional_deb"
			sudo -E apt install -f -y
		fi
	fi
}


function setup() {
	upgrade
	minimal
	general
	themes
	locale
	settings
	firewall
	dns
	albert
	autostart
	git-config
}

function _green_bold() {
	echo "$(tput setaf 2)$*$(tput sgr0)"
	echo ''
}


function minimal() {
	sudo -E add-apt-repository -y "deb http://archive.canonical.com/ $(lsb_release -sc) partner"

	sudo -E apt update -y

	# minimal
	sudo -E apt install -y file coreutils findutils vlock nnn ack sed tree grep silversearcher-ag
	sudo -E apt install -y python-pip python3-pip
	# Misc
	sudo -E apt install -y git tig gitg zsh less curl rename rsync openssh-server most multitail trash-cli libsecret-tools parallel ruby ntp vim fonts-noto fonts-roboto

	# Terminal multiplexing
	sudo -E apt install -y byobu tmux

	# System monitoring
	sudo -E apt install -y iotop htop nload glances

	# Networking tools
	sudo -E apt install -y nmap iputils-ping dnsutils telnet-ssl mtr-tiny traceroute libnss3-tools netdiscover
	# smbmap, only available in disco+

	# Cron
	sudo -E apt install -y cron cronic

	# Mailing
	sudo -E apt install -y msmtp-mta thunderbird

	# Cli browser with inline images
	sudo -E apt install -y w3m w3m-img

	# Apt tools
	sudo -E apt install -y apt-file wajig

	# Esential X tools
	# kdeconnect
	sudo -E apt install -y "shutter" redshift-gtk xfce4-terminal xfce4-genmon-plugin chromium-browser seahorse galculator orage ristretto \
		xsel xclip arandr wmctrl xscreensaver flatpak compton xfce4-appmenu-plugin

	_add_repo_or_install_deb 'ppa:hluk/copyq' 'copyq' 'https://github.com/hluk/CopyQ/releases/download/v3.9.3/copyq_3.9.3_Debian_10-1_amd64.deb'

	# File management and disk plugins
	sudo -E apt install -y cifs-utils exfat-fuse exfat-utils samba hfsprogs cdck ncdu mtp-tools

	# File management and disk plugins X
	sudo -E apt install -y thunar pcmanfm gnome-disk-utility

	# Remote desktop
	sudo -E apt install -y remmina vinagre xephyr


	# Language and spell check
	sudo -E apt install -y aspell

	git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

	# Editors
	sudo -E apt install -y geany vim-gtk3 emacs

	# Archiving
	sudo -E apt install -y engrampa unzip unrar p7zip-full ecm

	# Window managing
	# quicktile dependencies
	sudo -E apt install -y python python-gtk2 python-xlib python-dbus python-setuptools libpango-1.0
	_install_deb_from_url 'http://ftp.nl.debian.org/debian/pool/main/g/gnome-python-desktop/python-wnck_2.32.0+dfsg-3_amd64.deb'
	sudo -E pip2 install https://github.com/ssokolow/quicktile/archive/master.zip


 	sudo -E pip3 install git+https://github.com/jeffkaufman/icdiff.git

	# @todo set the gemrc files in place before running gem install
	#gem install teamocil
	ulauncher
	bash "$DIR/apps/oh-my-zsh.sh"
	# Fix for snaps with ZSH
	LINE="emulate sh -c 'source /etc/profile'"
	FILE=/etc/zsh/zprofile
	grep -qF -- "$LINE" "$FILE" || echo "$LINE" | sudo -E tee "$FILE"


	sudo -E snap install code --classic
	bash "$DIR/apps/code.sh"


	sudo -E chsh -s "$(command -v zsh)" mandy
}


function themes() {
	sudo -E apt install -y arc-theme bluebird-gtk-theme moka-icon-theme xfwm4-themes pocillo-icon-theme
}

function build-tools() {
	# Build tools
	sudo -E apt install -y build-essential dkms software-properties-common

}

function vpn() {
	# Vpn and network manager
	sudo -E apt install -y openvpn network-manager-openvpn network-manager-openvpn-gnome
}

function general() {
	set -e
	sudo -E apt update -y

	build-tools

	# System utils
	sudo -E apt install -y sysfsutils sysstat qdirstat

	# Media
	sudo -E apt install -y vlc quodlibet imagemagick

	vpn
	themes

	# Install android tools adbd for android-sdk icon and adb binary
	sudo -E apt install -y android-tools-adbd

	# PDF
	sudo -E apt install -y atril # zathura 'zathura*'

	if [ ! -f /usr/NX/bin/nxplayer ]; then
		# shellcheck disable=1001
		_install_deb_from_url "$(curl https://www.nomachine.com/download/download\&id\=6 2>/dev/null | grep -E -o "http.*download.*deb")"
	fi

	_add_repo_or_install_deb 'ppa:nextcloud-devs/client' 'nextcloud-client'

	if ! command -v bat &>/dev/null; then
		_install_deb_from_url https://github.com/sharkdp/bat/releases/download/v0.11.0/bat_0.11.0_amd64.deb
	fi

	_add_repo_or_install_deb 'ppa:mmstick76/alacritty' 'alacritty'

	if ! command -v fd &>/dev/null; then
		_install_deb_from_url https://github.com/sharkdp/fd/releases/download/v7.4.0/fd_7.4.0_amd64.deb
	fi

	if ! command -v x11docker &>/dev/null; then
		curl -fsSL https://raw.githubusercontent.com/mviereck/x11docker/master/x11docker | sudo -E bash -s -- --update
	fi

	_add_repo_or_install_deb 'ppa:lazygit-team/release' 'lazygit'

	_add_repo_or_install_deb 'ppa:webupd8team/indicator-kdeconnect' 'indicator-kdeconnect'

	if ! apt -qq list papirus-icon-theme 2>/dev/null | grep -i -q installed
	then
		_add_repo_or_install_deb 'ppa:papirus/papirus' 'papirus-icon-theme'
	fi

	sudo -E snap install ripgrep --classic


	yes | flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo --user
	flatpak install flathub com.github.wwmm.pulseeffects -y --user


	remove-obsolelete


	pip3 install thefuck
	pip3 install numpy
	pip3 install csvkit
	pip3 install httpie

	set +e
}

function remove-obsolete() {
	sudo -E apt remove -y parole mpv 'pidgin*'
	# Remove gnome games
	sudo -E apt remove -y aisleriot hitori sgt-puzzles lightsoff iagno gnome-games gnome-nibbles \
		gnome-mines quadrapassel gnome-sudoku gnome-robots swell-foop tali gnome-taquin \
		gnome-tetravex gnome-chess five-or-more four-in-a-row gnome-klotski gnome-mahjongg

	# Obsolete indicators
	sudo -E apt remove indicator-session indicator-datetime indicator-keyboard indicator-power -y
	sudo -E apt autoremove -y
}

function shutter() {
	# shellcheck disable=SC1091
	source /etc/lsb-release
	# http://ubuntuhandbook.org/index.php/2018/04/fix-edit-option-disabled-shutter-ubuntu-18-04/
	if [[ $DISTRIB_RELEASE = "18.04" ]]
	then
		_install_deb_from_url "https://launchpad.net/ubuntu/+archive/primary/+files/libgoocanvas-common_1.0.0-1_all.deb"
		_install_deb_from_url "https://launchpad.net/ubuntu/+archive/primary/+files/libgoocanvas3_1.0.0-1_amd64.deb"
		_install_deb_from_url "https://launchpad.net/ubuntu/+archive/primary/+files/libgoo-canvas-perl_0.06-2ubuntu3_amd64.deb"
	fi
	sudo -E apt install "shutter" -y

}

function groups() {
	sudo -E groupadd "docker"
	sudo -E groupadd vboxusers
	sudo -E groupadd mail
	sudo -E groupadd sambashare

	sudo -E usermod -aG "docker" mandy
	sudo -E usermod -aG mail mandy
	sudo -E usermod -aG disk mandy
	sudo -E usermod -aG cdrom mandy
	sudo -E usermod -aG vboxusers mandy
	sudo -E usermod -aG sudo -E mandy
	sudo -E usermod -aG sambashare mandy
	sudo -E usermod -aG netdev mandy
	sudo -E usermod -aG dialout mandy

}

function fonts() {
	installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/SourceCodePro.zip SourceCodeProNerdFont
	installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FantasqueSansMono.zip FantasqueSansMono
	installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/DroidSansMono.zip DroidSansMono
	installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/DejaVuSansMono.zip DejaVuSansMono
	installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Iosevka.zip Iosevka
	installFontsFromZip https://github.com/IBM/plex/releases/download/v1.4.1/OpenType.zip "IBM Plex"

	if [[ $fontsAdded -eq 1 ]]; then
		fc-cache -f -v
	fi
}


function settings-light() {
	xfce_settings-light
}

function settings-dark() {
	xfce_settings-dark
}


function settings-xfpanel() {
	xfpanel-switch load "$ROOT_DIR/.local/share/xfpanel-switch/Mandy Mac OS Style with global menu dual monitor.tar.bz2"
}


function settings() {
	xfce_settings
	# X11 forwarding over SSH
	sudo -E sed -i -E 's|.*X11UseLocalhost.*|X11UseLocalhost no|g' /etc/ssh/sshd_config
	sudo -E sed -i -E 's|.*X11Forwarding.*|X11Forwarding yes|g' /etc/ssh/sshd_config
}


function keybindings() {
	xfce_keybindings
}

function ulauncher() {
	_add_repo_or_install_deb 'ppa:agornostal/ulauncher' 'ulauncher' 'https://github.com/Ulauncher/Ulauncher/releases/download/5.4.0/ulauncher_5.4.0_all.deb'
}

function locale() {
	# Locale
	sudo -E locale-gen nl_BE
	sudo -E locale-gen nl_BE.UTF-8
	sudo -E locale-gen en_GB
	sudo -E locale-gen en_GB.UTF-8
	sudo -E locale-gen en_US
	sudo -E locale-gen en_US.UTF-8
	sudo -E update-locale

	sudo -E update-locale \
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
		cd "${TMPDIR:-/tmp}"
		/usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2019.02.01_all.deb keyring.deb SHA256:176af52de1a976f103f9809920d80d02411ac5e763f695327de9fa6aff23f416
		sudo -E dpkg -i ./keyring.deb
		echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo -E tee /etc/apt/sources.list.d/sur5r-i3.list
		sudo -E apt update
	fi

	sudo -E apt install -y udiskie compton nitrogen feh xfce4-panel pcmanfm spacefm rofi ssh-askpass-gnome
	sudo -E apt install -y "i3" i3blocks i3lock
	sudo -E apt install -y dmenu rofi
}


function openbox() {
	i3
	sudo -E apt install -y "openbox" obconf lxappearance xfce4-panel
}

function usb_ssd() {
	# Add usb3 SSD as usb-device instead of uas
	if [ ! -f /etc/modprobe.d/usb-storage.conf ]; then
		echo "options usb-storage quirks=174c:55aa:u" | sudo -E tee /etc/modprobe.d/usb-storage.conf
		sudo -E update-initramfs -u
	fi
}


function upgrade() {
	sudo -E apt update; sudo -E apt "upgrade" -y
	sudo -E apt install "linux-headers-$(uname -r)" dkms -y
	sudo -E /sbin/vboxconfig
	sudo -E apt autoremove -y
}


function media() {
	# Media things, disk burn software
	sudo -E apt install -y digikam k3b # darktable
	# Permissions for ripping cds
	sudo -E chmod 4711 /usr/bin/wodim;
	sudo -E chmod 4711 /usr/bin/cdrdao
}

function chat() {
	sudo -E snap install slack --classic
	sudo -E snap install discord --classic

}
function kde() {
	sudo -E apt install -y kronometer ktimer ark
	sudo -E apt remove -y konsole akonadi korganizer kaddressbook kmail kjots kalarm kmail amarok
	# @todo remove kde pim etc
}

function uninstall-kde() {
	# @todo gwenview ?
	sudo -E apt remove -y ark okular '*kwallet*' kdevelop kate kwrite kronometer ktimer
	sudo -E apt autoremove -y
}

function privacy() {
	# sudo -E apt install -y torbrowser-launcher
	# @todo add expressvpn
	_install_deb_from_url "https://s3.amazonaws.com/purevpn-dialer-assets/linux/app/purevpn_1.2.2_amd64.deb"
}


function macbook() {
	# Realtek drivers for MacBook
	sudo -E apt install firmware-b43-installer -y
}


function etcher() {
	echo "deb https://deb.etcher.io stable etcher" | sudo -E tee /etc/apt/sources.list.d/balena-etcher.list
	sudo -E apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
	sudo -E apt-get update
	sudo -E apt-get install balena-etcher-electron -y
}

function qt_dev() {
	# Qt development
	sudo -E apt install -y kdevelop qt5-default build-essential mesa-common-dev libglu1-mesa-dev
}


function jupyter() {
	pip3 install jupyterlab
	npm install -g ijavascript && ijsinstall
	pip3 install bash_kernel && python3 -m bash_kernel.install
	pip3 install gnuplot_kernel && python3 -m gnuplot_kernel install --user
	pip3 install qtconsole pyqt5
}

function dev() {
	sudo -E apt remove -y shellcheck
	if ! which shellcheck &>/dev/null; then
		scversion="stable" # or "v0.4.7", or "latest"
		wget -qO- "https://storage.googleapis.com/shellcheck/shellcheck-${scversion?}.linux.x86_64.tar.xz" | tar -xJv
		sudo -E cp "shellcheck-${scversion}/shellcheck" /usr/bin/
	fi

	if ! which hadolint &>/dev/null; then
		cd /tmp || exit 2
		wget -qO- "https://github.com/hadolint/hadolint/releases/download/v1.17.3/hadolint-Linux-x86_64" > hadolint
		sudo -E cp "hadolint" /usr/bin/
		sudo -E chmod +x /usr/bin/hadolint
	fi

	pip3 install mypy yamllint flake8 autopep8
	pip3 install pre-commit

	sudo -E apt install -y nodejs npm meld

	npm config set prefix "$HOME/.local"
	npm install -g bash-language-server
	npm install -g intelephense
	npm install -g bats

	if ! which circleci &>/dev/null; then
		curl -fLSs https://circle.ci/cli | sudo -E bash
	fi

	# Gnu global and exuberant ctags
	sudo -E apt install -y global ctags
}


function php() {
	sudo -E apt install -y wkhtmltopdf php-cli php-xml php-mbstring php-curl php-zip php-pdo-sqlite php-intl php-zmq
	sudo -E apt install -y kcachegrind
	sudo -E snap install phpstorm --classic
	pip3 install mycli


	if ! which composer &>/dev/null; then
		# shellcheck disable=SC2091
		curl -sS https://getcomposer.org/installer | $(which php) && sudo -E mv composer.phar /usr/local/bin/composer
	fi
	# shellcheck disable=SC2091
	curl -sS https://litipk.github.io/Jupyter-PHP-Installer/dist/jupyter-php-installer.phar > "${TMPDIR:-/tmp}/jupyter.php"
	$(which php) "${TMPDIR:-/tmp}/jupyter.php" install
	rm "${TMPDIR:-/tmp}/jupyter.php"
}


function docker() {
	sudo -E apt-get install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg2 \
		software-properties-common

	if ! which ctop &>/dev/null; then
		sudo -E wget https://github.com/bcicen/ctop/releases/download/v0.7.2/ctop-0.7.2-linux-amd64 -O /usr/local/bin/ctop
		sudo -E chmod +x /usr/local/bin/ctop
	fi

	if ! which docker &>/dev/null; then
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo -E apt-key add -
		sudo -E apt-key fingerprint 0EBFCD88
		sudo -E add-apt-repository \
			"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
			$(lsb_release -cs) \
			stable"
		sudo -E apt-get update
		sudo -E apt-get install -y docker-ce
		sudo -E usermod -aG "docker" "$(whoami)"
	fi

	if ! which docker-compose &>/dev/null; then
		sudo -E curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
		sudo -E chmod +x /usr/local/bin/docker-compose
	fi

	# if which podman &>/dev/null
	# then
	# 	# Podman
	# 	sudo -E apt update
	# 	sudo -E apt -y install software-properties-common
	# 	sudo -E add-apt-repository -y ppa:projectatomic/ppa
	# 	sudo -E apt install podman -y
	# fi

	cd "${TMPDIR:-/tmp}"
	if ! which lazydocker &>/dev/null; then
		curl -L https://github.com/jesseduffield/lazydocker/releases/download/v0.7.1/lazydocker_0.7.1_Linux_x86_64.tar.gz > lazydocker.tgz
		tar xzf lazydocker.tgz
		sudo -E install lazydocker /usr/local/bin/
	fi
}

function polybar() {
	sudo -E apt install -y build-essential git cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev
	sudo -E apt install -y libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev

	cd "${TMPDIR:-/tmp}"
	git clone https://github.com/jaagr/polybar.git
	cd polybar && ./build.sh --all-features --gcc --install-config --auto
}


function dns() {
	if [ ! -f /etc/NetworkManager/conf.d/00-use-dnsmasq.conf ]; then
		sudo -E tee /etc/NetworkManager/conf.d/00-use-dnsmasq.conf << EOL &>/dev/null
# This enabled the dnsmasq plugin.
[main]
dns=dnsmasq
EOL

		sudo -E tee /etc/NetworkManager/dnsmasq.d/00-home-mndy-be.conf << EOL &>/dev/null
address=/home.mndy.be/192.168.10.120
addn-hosts=/etc/hosts
EOL

		# use network manager instead of systemd resolve resolv.conf
		sudo -E rm /etc/resolv.conf; sudo -E ln -s /var/run/NetworkManager/resolv.conf /etc/resolv.conf
		sudo -E systemctl restart NetworkManager
	fi
}

function sysctl() {
	# @todo add https://askubuntu.com/questions/23674/netbook-freezes-with-high-load-on-every-io-operation to sysctl if IO performance is a problem
	sudo -E tee /etc/sysctl.d/mandy.conf << EOL &>/dev/null
# Virtual IPs
net.ipv4.ip_nonlocal_bind=1

# For IntelliJ products for example
# See https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
fs.inotify.max_user_watches = 524288

fs.inotify.max_user_watches = 524288
net.ipv4.ip_forward=1
kernel.printk = 2 4 1 7
vm.swappiness = 2
vm.max_map_count=262144
EOL

}

function firewall() {
	sudo -E ufw enable
	yes | sudo -E ufw reset
	sudo -E ufw allow ssh

	sudo -E ufw allow http
	sudo -E ufw allow https

	# pulse over HTTP
	sudo -E ufw allow 8080/udp
	sudo -E ufw allow 8080/tcp

	# access local hosts through vpn
	# shellcheck disable=SC2010
	sudo -E ip route add 192.168.10.0/24 "dev" "$(ls /sys/class/net | grep "^en*" | head -1)"
}

function git-config() {
	git config --global --replace-all submodule.recurse true
	git config --global --replace-all user.name 'Mandy Schoep'
	git config --global --replace-all fetch.prune true
	git config --global --replace-all diff.guitool meld
	echo "Manually execute 'git config --global user.email <email>'"
}

function autostart() {
	mkdir -p ~/.config/autostart
	cp /usr/share/applications/ulauncher.desktop ~/.config/autostart/
	cp /usr/share/applications/indicator-kdeconnect.desktop ~/.config/autostart/
	cp /usr/share/applications/redshift-gtk.desktop ~/.config/autostart/
	cp /usr/share/applications/com.github.hluk.copyq.desktop ~/.config/autostart/
	cp /usr/share/applications/nextcloud.desktop ~/.config/autostart/
	cp "$ROOT_DIR/.local/share/applications/Compton.desktop" ~/.config/autostart/
	update-desktop-database
}

function gaming() {
	lutris
	sudo -E apt install -y steam
}


function fail() {
	exit 233
}

## Gaming section
function lutris() {
	_add_repo_or_install_deb 'ppa:lutris-team/lutris' 'lutris'
}

set -e

# shellcheck source=../.functions
source "$ROOT_DIR/.functions"
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
		function_location="$(declare -f -F "$f" | cut -d' ' -f3)"
		if [[ "${f:0:1}" != "_" ]] && [[ "$function_location" == "${BASH_SOURCE[0]}" ]]; then
			echo " --${f}"
		fi
	done
}


if [[ $# -eq 0 ]]; then
	_print_usage
else
	shopt -s extdebug
	for i in "$@"
	do
		function="$(echo "${i}" | sed -E 's/^-+//g')"
		starts_with_underscore=0
		if [[ "${i::1}" == '_' ]]; then
			starts_with_underscore=1
		fi
		if [[ "$function" == "help" ]]; then
			_print_usage
			exit 0
		fi
		function_location="$(declare -F "$function" | cut -d' ' -f3)"
		if [[ -n "$(declare -f -F "$function")" ]] && [[ "$function_location" == "${BASH_SOURCE[0]}" ]] && [ $starts_with_underscore -eq 0 ]; then
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
