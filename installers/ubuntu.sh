#!/usr/bin/env bash

# shellcheck disable=SC2230
# shellcheck disable=SC2155
# to test this script: `docker run --rm -v "${PWD}:${PWD}:ro" -it "ubuntu-mandy:0.1-20.04" -c "$PWD/installers/ubuntu.sh --ulauncher"`

if [[ $UID -eq 0 ]]; then
	echo "Run this script as non root user please..."
	exit 99
fi


fontsAdded=0

if [[ ! -z $BASH_SOURCE ]]; then
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	cd "$DIR" || exit 1
fi

set -e -o functrace

this_command=''
previous_command=''
trap 'previous_command=$this_command; this_command=$BASH_COMMAND' DEBUG
___finish() {
	>&2 echo "Error while executing '$previous_command' in $0, line $1"
	exit $?
}
trap '___finish $LINENO' ERR

___shutdown() {
	exit 99
}
trap "___shutdown" INT TERM

if command -v git &>/dev/null; then
	ROOT_DIR="$(git rev-parse --show-toplevel)/"
fi

source /etc/lsb-release


function cpu_architecture() {
	if type -P uname &>/dev/null; then
		uname -m
	fi
}


function  cpu_architecture_simple() {
	cpu_architecture="$(cpu_architecture)"
	if [[ $cpu_architecture = 'x86_64' ]]; then
		echo "amd64"
	elif [[ $cpu_architecture = 'i686' ]]; then
		echo "i386"		
	elif [[ $cpu_architecture = 'aarch64' ]]; then
		echo "arm64"
	elif [[ $cpu_architecture = 'aarch32' ]]; then
		echo "armhf"
	fi	
}

function is_ubuntu() {
	[[ $(lsb_release -s -i 2>/dev/null) = 'Ubuntu' ]]
}

apt_quiet="-qq"
function debug() {
	apt_quiet=
}
if ! is_ubuntu; then
	echo "You are running on a non Ubuntu system"
	exit 101
fi




export DEBIAN_FRONTEND=noninteractive

function vv() {
	set -x
}

function _install_deb_from_url() {
	local url="$1"
	local tmp="$(mktemp)"
	if ! type -P curl &>/dev/null; then
		_install curl
	fi
	curl -sSL "$url" >> "$tmp"
	sudo -E dpkg -i "$tmp" || true
	sudo -E apt-get $apt_quiet install -f -y
}

function _is_x_package() {
	{
		set +e; sudo -E apt-rdepends "$*" 2>/dev/null| grep 'Depends: libx11' &>/dev/null 
	}
}

function _is_installed() {
	apt list $apt_quiet "$@" 2>/dev/null | grep 'installed' &>/dev/null
}

function _add_repo_or_install_deb() {
	local repo="$1"
	local package_name="$2"
	local optional_deb="$3"

	if ! command -v "$package_name" &>/dev/null; then
		_add_repository "$repo"
		_install "$package_name"
	fi

	# still no package?? remove repo and install deb
	if ! command -v "$package_name" &>/dev/null; then
		sudo -E add-apt-repository --remove "$repo" -y
		if [[ $optional_deb != '' ]]; then
			_install_deb_from_url "$optional_deb"
			sudo -E apt-get $apt_quiet install -f -y
		fi
	fi
}


function _list_repositories() {
	grep -rE '^deb'  /etc/apt/sources.list /etc/apt/sources.list.d | grep -Eo 'https?://[^ ]+.*'
}

function _add_repository() {
	if ! type -P add-apt-repository &>/dev/null; then
		_install software-properties-common
	fi
	# shellcheck disable=SC2068
	sudo -E add-apt-repository -y "$@"
}

# install_x=0
# function no-x() {
# 	install_x=1
# }


function installFontsFromZip() {
	local fontUrl="$1"
	local fontName="$2"
	if [ "$(uname)" = 'Darwin' ]; then
		mkdir -p ~/Library/Fonts || exit 2
		cd ~/Library/Fonts || exit 1
	else
		mkdir -p ~/.local/share/fonts || exit 2
		cd ~/.local/share/fonts || exit 1
	fi

	if [ ! -d "$fontName" ]; then
		rm -f "${TMPDIR:-/tmp}/$fontName.zip"
		curl -LsSo "${TMPDIR:-/tmp}/$fontName.zip" "$fontUrl"
		unzip "${TMPDIR:-/tmp}/$fontName.zip" -d "$fontName"
		fontsAdded=1
		deleteWindowsFonts
	fi
}

function deleteWindowsFonts() {
	if [ "$(uname)" = 'Darwin' ]; then
		local DIR=~/Library/Fonts
	else
		local DIR=~/.local/share/fonts
	fi
	find $DIR -iname '*windows*' -exec rm -r "{}" \;
}



function _install() {
	# echo "Installing '$*' through apt"
	set -e
	new_args="$*"
	# if [[ $install_x -eq 1 ]]; then
	# 	# _update
	# 	args=$(echo "$@" | tr ' ' '\n')
	# 	new_args=$args
	# 	for i in $args
	# 	do
	# 		if _is_x_package "$i"; then
	# 			echo "$i is x package"
	# 			new_args=${new_args//$i/}
	# 		fi
	# 	done
	# 	args=$(echo "$new_args" | tr '\n' ' ')
	# fi

	# shellcheck disable=SC2086
	sudo -E apt-get $apt_quiet install -y $new_args
	set +e
}

function _install_flatpak_flathub() {
	set -e
	if ! type -P flatpak &>/dev/null; then
		_install flatpak
	fi

	yes | sudo -E flatpak remote-add --if-not-type -P flathub &>/dev/null https://flathub.org/repo/flathub.flatpakrepo --system
	sudo -E flatpak install flathub "$*" --system -y
	set +e
}

function _install_pip3() {
	set -e
	if ! type -P pip3 &>/dev/null; then
		_install python3-pip
	fi
	# shellcheck disable=SC2068
	python3 -m pip install --user $@  >/dev/null
	set +e
}

function _install_pipx() {
	set -e
	if ! type -P pipx &>/dev/null; then
		_install_pip3 pipx
	fi
	if ! python3 -m venv -h &>/dev/null; then
		_install python3-venv
	fi
	pipx ensurepath &>/dev/null
	echo "$@" | tr -d '\n' | xargs -d' ' -r -i sudo -E pip3 uninstall -q -y {} &>/dev/null | true
	echo "$@" | tr -d '\n' | xargs -d' ' -r -i python3 -m pip uninstall --user -q -y {} &>/dev/null | true
	# shellcheck disable=SC2068
	echo "$@" | tr -d '\n' | xargs -d' ' -r -i pipx install {} --include-deps --pip-args="-q --force"  >/dev/null
	set +e
}

function _install_snap() {
	set -e
	if ! type -P snap &>/dev/null; then
		_install snapd
	fi
	# shellcheck disable=SC2068
	sudo -E snap install $@
	set +e
}

function _install_pip() {
	set -e
	if ! type -P pip &>/dev/null; then
		_install python-pip
	fi
	# shellcheck disable=SC2068
	sudo -E pip install -q $@
	set +e
}

function _install_gem() {
	if ! type -P gem &>/dev/null; then
		_install ruby ruby-dev
	fi

	# shellcheck disable=SC2068
	gem install --user-install $@
}

updated=0
function _update() {
	if [[ $updated -eq 0 ]]; then
		sudo -E apt-get update -y $apt_quiet >/dev/null
	fi
	updated=1
}

function _force_update() {
	sudo -E apt-get update -y $apt_quiet >/dev/null
}

function _remove() {
	# shellcheck disable=SC2068
	sudo -E apt-get $apt_quiet remove -y $@
}

function _remove_and_purge() {
	_remove "$@"
	_purge "$@"
}

function _purge() {
	# shellcheck disable=SC2068
	sudo -E apt-get $apt_quiet purge -y $@
}

function _autoremove() {
	sudo -E apt-get $apt_quiet autoremove -y
}


function setup() {
	upgrade
	minimal
	general
	themes
	locale
	fonts
	settings
	firewall
	networkmanager
	autostart
	git-config
}

function _green_bold() {
	echo "$(tput setaf 2)$*$(tput sgr0)"
	echo ''
}



function minimal() {
	_add_repository -n "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
 	_add_repository ppa:git-core/ppa
	_force_update

	# fd-find is available from 19.10
	_install git git-extras tig tmux tree gawk htop zsh less curl wget rsync openssh-server ssh-askpass vim nmap iputils-ping dnsutils unzip unrar p7zip fd-find bat

	# git diff tool with syntax highlighting
	install_deb_from_url https://github.com/dandavison/delta/releases/download/0.5.1/git-delta_0.5.1_amd64.deb

	_install_gem teamocil

	zsh
}

function minimal-desktop() {
	declare -a packages=()

	# XFCE ONLY      xfce4-genmon-plugin xfdashboard  galculator
	packages+=(redshift-gtk xfce4-terminal seahorse mate-utils orage ristretto 
		xsel xclip arandr wmctrl flatpak compton catfish rofi xdotool)

	# File management and disk plugins X
	packages+=(thunar gnome-disk-utility)

	# Remote desktop
	packages+=(remmina 'remmina*plugin*' vinagre xserver-xephyr)

	_purge xfce4-appmenu-plugin || true
	_purge copyq || true
	_purge chromium-browser || true

	chrome

	# Editors
	packages+=(geany)

	# Archiving    ecm
	packages+=(engrampa) # of p7zip-full on 1804

	_install "${packages[*]}"


	ulauncher

	_install_snap code --classic
	nodejs
	bash "$DIR/apps/code.sh"

}

function sysadmin() {
	declare -a packages=()

	# System monitoring
	packages+=(iotop htop nload glances)

	# Networking tools
	packages+=(net-tools nmap iputils-ping dnsutils telnet-ssl mtr-tiny traceroute libnss3-tools netdiscover whois bridge-utils trickle ipvsadm)


	_install "${packages[*]}"
}

function minimal-old() {
	declare -a packages=()

	# minimal
	packages+=(file coreutils findutils vlock nnn ack sed tree grep silversearcher-ag gawk)
	packages+=(python3-pip bsdmainutils)



	# Misc
	packages+=(git git-extras tig gitg zsh iproute2 man pv autojump less curl rename rsync rclone openssh-server most multitail trash-cli zenity libsecret-tools parallel ruby ruby-dev ntp neovim vim-gtk3 fonts-noto-color-emoji fonts-noto fonts-roboto)

	# Misc X
	packages+=(rclone-browser)

	# Terminal multiplexing
	packages+=(byobu tmux)

	# System monitoring
	packages+=(iotop htop nload glances)

	# Networking tools
	packages+=(nmap iputils-ping dnsutils telnet-ssl mtr-tiny traceroute libnss3-tools netdiscover whois bridge-utils trickle ipvsadm)
	# smbmap, only available in disco+

	# Cron
	packages+=(cron cronic)

	# Mailing
	packages+=(msmtp-mta)

	# Cli browser with inline images
	packages+=(w3m w3m-img)

	# Spelling  python-hunspell
	packages+=(aspell hyphen-en-gb hyphen-nl hunspell aspell-nl hunspell-nl aspell-en hunspell-en-gb hunspell-en-us hunspell-no aspell-no libgspell-1-2 libgtkspell0 python3-hunspell)

	# Apt tools
	packages+=(apt-file wajig apt-rdepends gnome-software)

	packages+=(xmlstarlet)

	# Esential X tools
	# kdeconnect   shutter

	# XFCE ONLY      xfce4-genmon-plugin xfdashboard  galculator
	packages+=(redshift-gtk xfce4-terminal seahorse galculator orage ristretto 
		xsel xclip arandr wmctrl xscreensaver flatpak compton catfish rofi xdotool ssh-askpass)

	_purge xfce4-appmenu-plugin || true
	_purge copyq || true
	_purge chromium-browser || true
	

	# File management and disk plugins
	packages+=(cifs-utils exfat-fuse exfat-utils samba hfsprogs cdck ncdu mtp-tools ranger)

	# File management and disk plugins X
	packages+=(thunar pcmanfm gnome-disk-utility)

	# Remote desktop
	packages+=(remmina 'remmina*plugin*' vinagre xserver-xephyr)

	# Mouse and keyboard
	packages+=(imwheel)

	#git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

	chrome

	# Fix for DRM in Chromium becaue winevinecdm is a proprietary piece of code
#	sudo -E ln -fs /opt/google/chrome/WidevineCdm /usr/lib/chromium-browser/WidevineCdm

	# Audio
	if ! type -P playerctl &>/dev/null; then
		_install_deb_from_url "https://github.com/altdesktop/playerctl/releases/download/v2.0.2/playerctl-2.0.2_$(cpu_architecture_simple).deb"
	fi

	# Drivers
	packages+=(rtl8812au-dkms)

	# Editors
	packages+=(geany vim-gtk3)

	# Archiving    ecm
	packages+=(engrampa unzip unrar p7zip) # of p7zip-full on 1804

	_install "${packages[*]}"

 	# _install_pip3 git+https://github.com/jeffkaufman/icdiff.git


	_install_gem teamocil
	
	ulauncher

	zsh

	_install_snap code --classic
	bash "$DIR/apps/code.sh"

}

function chrome() {
	_install_deb_from_url "https://dl.google.com/linux/direct/google-chrome-stable_current_$(cpu_architecture_simple).deb"
}

function zsh() {
	_install zsh
	bash "$DIR/apps/oh-my-zsh.sh"
	# Fix for snaps with ZSH
	LINE="emulate sh -c 'source /etc/profile'"
	FILE=/etc/zsh/zprofile
	grep -qF -- "$LINE" "$FILE" || echo "$LINE" | sudo -E tee "$FILE" >/dev/null
	sudo -E chsh -s "$(which zsh)" "$(whoami)"
}

function quicktile() {
	declare -a packages=()
	# Window managing
	# quicktile dependencies
	packages+=(python3 python3-pip python3-setuptools python3-gi python3-xlib python3-dbus gir1.2-glib-2.0 gir1.2-gtk-3.0 gir1.2-wnck-3.0)

	_install "${packages[*]}"
	# _install_deb_from_url "http://ftp.nl.debian.org/debian/pool/main/g/gnome-python-desktop/python-wnck_2.32.0+dfsg-3_$(cpu_architecture_simple).deb"
	_install_pip3 https://github.com/ssokolow/quicktile/archive/master.zip

}

function themes() {
	declare -a packages=()
	# packages+=(xfwm4-themes)
	packages+=(arc-theme bluebird-gtk-theme moka-icon-theme 'yaru-*')
	_install "${packages[*]}"
	papirus
}

function build-tools() {
	# Build tools
	declare -a packages=()
	packages+=(build-essential dkms software-properties-common)
	_install "${packages[*]}" 
}

function vpn() {
	# Vpn and network manager
	declare -a packages=()
	packages+=(openvpn network-manager-openvpn network-manager-openvpn-gnome)
	_install "${packages[*]}" 
}

function general() {
	set -e
	_update

	build-tools

	declare -a packages=()
	# System utils
	packages+=(sysfsutils sysstat mate-utils run-one)

	# Media
	packages+=(vlc imagemagick flac soundconverter picard)
	
	# _install_flatpak_flathub io.github.quodlibet.QuodLibet
	# _install_flatpak_flathub org.gnome.design.Contrast

	vpn
	themes

	# Install android tools adbd for android-sdk icon and adb binary
	packages+=(android-tools-adb)

	# PDF
	packages+=(atril)

	# Audio
	packages+=(pulseeffects pasystray pavucontrol lsp-plugins-lv2)
	# Terminal
	packages+=(tilda)

	nomachine
	# _add_repo_or_install_deb 'ppa:nextcloud-devs/client' 'nextcloud-client'

	if ! type -P bat &>/dev/null; then
		_install_deb_from_url "https://github.com/sharkdp/bat/releases/download/v0.17.1/bat_0.17.1_$(cpu_architecture_simple).deb"
	fi

	_add_repo_or_install_deb 'ppa:mmstick76/alacritty' 'alacritty'

	# if [[ "$DISTRIB_CODENAME" = 'bionic' ]]; then
	# 	if ! type -P fd &>/dev/null; then
	# 	_install_deb_from_url "https://github.com/sharkdp/fd/releases/download/v7.4.0/fd_7.4.0_$(cpu_architecture_simple).deb"
	# 	fi
	# else
	# 	packages+=(rust-fd-find)
	# fi

	# if ! command -v x11docker &>/dev/null; then
		# curl -sSL https://raw.githubusercontent.com/mviereck/x11docker/master/x11docker | sudo -E bash -s -- --update
	# fi

	# _add_repo_or_install_deb 'ppa:lazygit-team/release' 'lazygit'


	papirus

	_install_snap ripgrep --classic


	_install "${packages[*]}" 


	# ibus_typing_booster

	remove_obsolete
	# _install_pip3 thefuck numpy csvkit httpie

	# install_deb_from_url "https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.1.0/appimagelauncher_2.1.0-travis897.d1be7e7.bionic_$(cpu_architecture_simple).deb"

	# sudo -E curl -LsS "https://dystroy.org/broot/download/$(cpu_architecture)-linux/broot" -o /usr/local/bin/broot
	# sudo -E chmod +x /usr/local/bin/broot

	set +e
}

function papirus() {
	if ! apt-get $apt_quiet list papirus-icon-theme 2>/dev/null | grep -i -q installed
	then
		_add_repo_or_install_deb 'ppa:papirus/papirus' 'papirus-icon-theme'
	fi
}


function remove_obsolete() {
	_remove_and_purge parole mpv 'pidgin*' 'zathura*' evince
	# Remove gnome games
	_remove_and_purge aisleriot hitori 'sgt-*' lightsoff iagno gnome-games gnome-nibbles \
		gnome-mines quadrapassel gnome-sudoku gnome-robots swell-foop tali gnome-taquin \
		gnome-tetravex gnome-chess five-or-more four-in-a-row gnome-klotski gnome-mahjongg emacs

	# Obsolete indicators
	_remove_and_purge indicator-session indicator-datetime indicator-keyboard indicator-power

	# remove KDE/Plasma/QT applications
	_remove_and_purge 'okular*' qdirstat ktimer 'kubuntu*' '*kdeconnect*' kmail plasma-workspace 'kate5*' korganizer 'kdepim*'
	_autoremove
}

function groups() {
	sudo -E groupadd --system --force "docker" || true
	sudo -E groupadd --system --force vboxusers || true
	sudo -E groupadd --system --force mail || true
	sudo -E groupadd --system --force sambashare || true
	sudo -E groupadd --system --force audio || true
	sudo -E groupadd --system --force video || true
	sudo -E groupadd --system --force kvm || true
	sudo -E groupadd --system --force lxd || true
	sudo -E groupadd --system --force render || true
	sudo -E groupadd --system --force wireshark || true

	sudo -E usermod -aG "docker" mandy
	sudo -E usermod -aG mail mandy
	sudo -E usermod -aG audio mandy
	sudo -E usermod -aG video mandy
	sudo -E usermod -aG disk mandy
	sudo -E usermod -aG cdrom mandy
	sudo -E usermod -aG vboxusers mandy
	sudo -E usermod -aG sudo mandy
	sudo -E usermod -aG sambashare mandy
	sudo -E usermod -aG netdev mandy
	sudo -E usermod -aG plugdev mandy
	sudo -E usermod -aG input mandy
	sudo -E usermod -aG dialout mandy
	sudo -E usermod -aG kvm mandy
	sudo -E usermod -aG lxd mandy
	sudo -E usermod -aG render mandy
	sudo -E usermod -aG wireshark mandy
}

function nomachine() {
	if [ ! -f /usr/NX/bin/nxplayer ]; then
		# shellcheck disable=1001
		_install_deb_from_url "$(curl -sSL https://www.nomachine.com/download/download\&id\=2 2>/dev/null | grep -E -o "http.*download.*deb")"
	fi
}

function unetbootin() {
	_add_repository ppa:gezakovacs/ppa
	_update
	_install unetbootin
}

function jack() {
	# sudo -E sudo dpkg --purge kxstudio-repos-gcc5 || true
	# _install_deb_from_url https://launchpad.net/\~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_10.0.3_all.deb
	# _install jackd2 carla-git cadence non-mixer pulseaudio-module-jack mididings lsp-plugins
	# ln -sf "${ROOT_DIR}"/.local/share/applications/JackAudio.desktop ~/.config/autostart/

	sudo -E usermod -aG audio mandy
}

function fonts() {
	# installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/SourceCodePro.zip SourceCodeProNerdFont
	# installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FantasqueSansMono.zip FantasqueSansMono
	# installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip DroidSansMono
	# installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DejaVuSansMono.zip DejaVuSansMono
	# installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Iosevka.zip Iosevka
	# installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Inconsolata.zip Inconsolata
	installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip JetBrainsMono
	installFontsFromZip https://github.com/IBM/plex/releases/download/v4.0.2/OpenType.zip "IBM Plex"

	if [[ $fontsAdded -eq 1 ]]; then
		fc-cache -f -v
	fi
}


function settings-light() {
	# shellcheck source=./../settings/xfce.sh
	source "$DIR/../settings/xfce.sh"
	xfce_settings-light
}

function settings-dark() {
	# shellcheck source=./../settings/xfce.sh
	source "$DIR/../settings/xfce.sh"
	xfce_settings-dark
}


function settings-xfpanel() {
	xfpanel-switch load "$ROOT_DIR/.local/share/xfpanel-switch/Mandy Mac OS Style with global menu dual monitor.tar.bz2"
}


function settings() {
	# shellcheck source=./../settings/xfce.sh
	source "$DIR/../settings/xfce.sh"
	xfce_settings

	# @todo lightdm_settings

	xfce4-panel-profiles load ~/dotfiles/.local/share/xfpanel-switch/Mandy\ Mac\ OS\ Style\ with\ global\ menu\ dual\ monitor.tar.bz2
	
	# X11 forwarding over SSH
	sudo -E sed -i -E 's|.*X11UseLocalhost.*|X11UseLocalhost no|g' /etc/ssh/sshd_config
	sudo -E sed -i -E 's|.*X11Forwarding.*|X11Forwarding yes|g' /etc/ssh/sshd_config
}


function keybindings() {
	# shellcheck source=./../settings/xfce.sh
	source "$DIR/../settings/xfce.sh"
	xfce_keybindings
}

function ulauncher() {
	unset -f ulauncher
	_add_repo_or_install_deb 'ppa:agornostal/ulauncher' 'ulauncher' 'https://github.com/Ulauncher/Ulauncher/releases/download/5.7.4/ulauncher_5.7.4_all.deb'
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
	unset -f i3

	if [[ -f /etc/apt/sources.list.d/sur5r-i3.list ]]; then
		sudo -E rm /etc/apt/sources.list.d/sur5r-i3.list
	fi

	declare -a packages=()
	_remove spacefm
	packages+=(udiskie compton nitrogen feh xfce4-panel pcmanfm rofi ssh-askpass-gnome)
	packages+=("i3" i3blocks i3lock)
	packages+=(dmenu rofi)
	_install "${packages[*]}" 
}


function openbox() {
	unset -f openbox
	i3
	declare -a packages=()
	packages+=("openbox" obconf lxappearance xfce4-panel)
	_install "${packages[*]}" 
}

function usb_ssd() {
	# Add usb3 SSD as usb-device instead of uas
	if [ ! -f /etc/modprobe.d/usb-storage.conf ]; then
		echo "options usb-storage quirks=174c:55aa:u" | sudo -E tee /etc/modprobe.d/usb-storage.conf
		sudo -E update-initramfs -u
	fi
}


function upgrade() {
	_update
	sudo -E apt "upgrade" -y $apt_quiet
	sudo -E apt install "linux-headers-$(uname -r)" dkms -y
	if [[ -f /sbin/vboxconfig ]]; then
		sudo -E /sbin/vboxconfig
	fi
	_autoremove
}


function media() {
	declare -a packages=()
	# Media things, disk burn software
	packages+=(digikam k3b darktable krita)

	# add ffmpegfs for 20.04

	_install "${packages[*]}" 
	# Permissions for ripping cds
	sudo -E chmod 4711 /usr/bin/wodim;
	sudo -E chmod 4711 /usr/bin/cdrdao
}

function chat() {
	_install_snap slack --classic
	_install_snap discord --classic
	# Use deb to make use of fonts-noto-color-emoji
	_install_deb_from_url https://discordapp.com/api/download?platform=linux\&format=deb

	# if ! type -P slack-term &>/dev/null; then
		# sudo curl -LsS https://github.com/erroneousboat/slack-term/releases/download/v0.4.1/slack-term-linux-amd64 -o /usr/local/bin/slack-term
		# sudo chmod +x /usr/local/bin/slack-term
	# fi

	# if ! type -P signal-desktop &>/dev/null; then
		# curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
		# echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
		# _force_update
		# _install signal-desktop
	# fi
}

function kde() {
	packages+=(kronometer ktimer ark kubuntu-desktop filelight)
		_install "${packages[*]}" 

	_remove konsole korganizer kaddressbook kmail kjots kalarm kmail amarok kmines
	# @todo remove kde pim etc
}

function uninstall-kde() {
	# @todo gwenview ?
	_remove ark okular '*kwallet*' kdevelop kate kwrite kronometer ktimer
	_autoremove
}

function privacy() {
	# packages+=(torbrowser-launcher)
	# @todo add expressvpn
	_install_deb_from_url "https://s3.amazonaws.com/purevpn-dialer-assets/linux/app/purevpn_1.2.2_$(cpu_architecture_simple).deb"
	_install_deb_from_url "https://download.expressvpn.xyz/clients/linux/expressvpn_2.4.4.19_1_$(cpu_architecture_simple).deb"
}


function macbook() {
	# Realtek drivers for MacBook
	_install firmware-b43-installer
}


function ibus_typing_booster() {
	_install ibus libibus-1.0-dev hyphen-en-gb hyphen-nl hunspell aspell-nl hunspell-nl aspell-en hunspell-en-gb hunspell-en-us hunspell-no aspell-no
	# if [[ ! -d /usr/lib/ibus/ibus-engine-typing-booster ]]; then
	# 	cd /tmp
	# 	git clone git://github.com/mike-fabian/ibus-typing-booster.git
	# 	cd ibus-typing-booster
	# 	./autogen.sh
	# 	make
	# 	sudo make install
	# fi
}

function etcher() {
	echo "deb https://deb.etcher.io stable etcher" | sudo -E tee /etc/apt/sources.list.d/balena-etcher.list
	sudo -E apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
	_update
	_install balena-etcher-electron -y
}

function qt_dev() {
	# Qt development
	declare -a packages=()
	packages+=(kdevelop qt5-default build-essential mesa-common-dev libglu1-mesa-dev)
	_install "${packages[*]}" 
}


function virt-manager() {
	_install "virt-manager qemu-system qemu-kvm"

#  sudo nmcli conn add type bridge con-name br0 ifname br0
#  sudo nmcli conn add type ethernet slave-type bridge con-name bridge-br0 ifname enp0s31f6 master br0
#  sudo nmcli conn show --active
#  sudo nmcli conn up br0
#  sudo nmcli conn show --active
#  sudo nmcli conn up br0
#  sudo nmcli conn show --active
#  sudo nmcli conn show
#  sudo nmcli conn down Wired\ connection\ 1
}

function jupyter() {
	unset -f jupyter
	_install_pip3 jupyterlab
	npm install -g --silent ijavascript && ijsinstall
	_install_pip3 bash_kernel && python3 -m bash_kernel.install
	_install_pip3 gnuplot_kernel && python3 -m gnuplot_kernel install --user
	_install_pip3 qtconsole pyqt5
}


function nodejs() {
	declare -a packages=()
	curl -sSL https://deb.nodesource.com/setup_12.x | sudo -E bash - >/dev/null
	packages+=(nodejs build-essential)
	packages+=(jq)
	_install "${packages[*]}" 

	if ! type -P yq &>/dev/null; then
		sudo -E curl -LsS "https://github.com/mikefarah/yq/releases/download/3.0.1/yq_linux_$(cpu_architecture_simple)" -o /usr/local/bin/yq
		sudo -E chmod +x /usr/local/bin/yq
	fi
	sudo -E npm install -g --silent --force json >/dev/null
}

function dev() {
	declare -a packages=()
	if type -P snap &>/dev/null && ! type -P snapcraft &>/dev/null; then
		sudo -E snap install snapcraft --classic
	fi

	# bless is a hex editor
	# apache2-utils contains ab
	packages+=(apache2-utils multitail virt-what proot bless shellcheck)


	cd /tmp || exit 2
	curl -sSL "https://github.com/hadolint/hadolint/releases/download/latest/hadolint-Linux-$(cpu_architecture)" > hadolint
	sudo -E cp -f "hadolint" /usr/bin/
		sudo -E chmod +x /usr/bin/hadolint
	
	packages+=(python3-dev python3-pip python3-venv python3-wheel golang-go pandoc)
	_install "${packages[*]}"
	packages=()
	_install_pipx mypy yamllint flake8 autopep8 vim-vint spybar stormssh
	_install_pip3 dockerfile

	# python3 version is not in pypi
	# pip install crudini

	# if [[ ! -d ~/.mypyls ]]; then
	# 	python3 -m venv ~/.mypyls
	# 	~/.mypyls/bin/pip install "https://github.com/matangover/mypyls/archive/master.zip#egg=mypyls[default-mypy]"
	# fi

	_install_pip3 pre-commit
	# nodejs
	packages+=(meld)

	# Vscode dependencies
	packages+=(libsecret-1-dev libx11-dev libxkbfile-dev)
	_install "${packages[*]}" 

	npm config set loglevel error
	sudo -E npm install -g --silent --force bash-language-server >/dev/null
	sudo -E npm install -g --silent --force intelephense >/dev/null
	sudo -E npm install -g --silent --force bats >/dev/null
	sudo -E npm install -g --silent --force json >/dev/null
	sudo -E npm install -g --silent --force fixjson jsonlint >/dev/null
	sudo -E npm install -g --silent --force eslint >/dev/null
	sudo -E npm install -g --silent --force markdownlint-cli >/dev/null
	sudo -E npm install -g --silent --force @marp-team/marp-cli >/dev/null
	sudo -E npm install -g --silent --force yarn >/dev/null
	sudo -E npm install -g --silent --force gulp >/dev/null

	# if ! type -P circleci &>/dev/null; then
	# 	curl -sSL https://circle.ci/cli | sudo -E bash
	# 	sudo groupadd -g 3434 circleci
	# 	sudo useradd -u 3434 -g circleci circleci 
	# 	sudo usermod -aG docker circleci
	# fi

	# Gnu global and exuberant ctags
	packages+=(global ctags)

	if ! type -P checkmake &>/dev/null; then
		go get github.com/mrtazz/checkmake
		cd "$GOPATH/src/github.com/mrtazz/checkmake"
		sudo make PREFIX=/usr/local clean install    
	fi

	_install "${packages[*]}" 

	# virtualization

	# curl -s "https://get.sdkman.io" | bash  # install sdkman
	# sdk install kotlin                      # install Kotlin

	# _install_deb_from_url https://packages.microsoft.com/config/ubuntu/19.10/packages-microsoft-prod.deb
	# _install apt-transport-https 
	# _install dotnet-sdk-3.1

}


function lxd() {
	sudo -E snap install multipass --classic
	sudo -E snap install lxd
	sudo -E 'lxd' init --auto
	sudo usermod -aG lxd "$(whoami)"
}


function virtualbox() {
	unset -f virtualbox
	if [ ! -f /etc/apt/sources.list.d/virtualbox.list ]; then
		echo "deb [arch=$(cpu_architecture_simple)] https://download.virtualbox.org/virtualbox/debian $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) contrib" | sudo -E tee /etc/apt/sources.list.d/virtualbox.list
		wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
		wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
	fi
	packages+=(VirtualBox-6.1)
	_install "${packages[*]}" 

	# @see https://pgaskin.net/linux-tips/configuring-virtualbox-autostart/
	sudo -E mkdir -p /etc/vbox
	sudo -E tee /etc/vbox/autostart.cfg << EOL &>/dev/null
default_policy = deny
mandy = {
allow = true
}
EOL
	sudo -E chgrp vboxusers /etc/vbox
	sudo -E chmod 1775 /etc/vbox
	VBoxManage setproperty autostartdbpath /etc/vbox
	sudo -E systemctl restart vboxautostart-service.service 
	sudo -E systemctl enable vboxautostart-service.service 


	vagrant
}


function vagrant() {
	_install_deb_from_url "https://releases.hashicorp.com/vagrant/2.2.7/vagrant_2.2.7_$(cpu_architecture).deb"
}


function audio() {
	sudo apt-get update
	_install flacon flac

	_install_deb_from_url https://launchpad.net/\~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_10.0.3_all.deb

	sudo -E dpkg --purge kxstudio-repos-gcc5 | true
	_install jackd2 carla-git cadence jack-mixer pulseaudio-module-jack mididings lsp-plugins liblash-compat-1debian0 jack-mixer
	_install_pip gconf
}

function php() {
	unset -f php
	
	# _add_repository ppa:ondrej/php


	declare -a packages=()
	# packages+=(wkhtmltopdf php7.4-cli php7.4-opcache php7.4-zip php7.4-curl php7.4-yaml)
	# packages+=(php7.4-phpdbg php7.4-xml php7.4-mbstring php7.4-curl php7.4-zip php7.4-pdo-sqlite php7.4-intl php7.4-zmq)
	packages+=(kcachegrind)

	_install "${packages[*]}" 

	_install_snap phpstorm --classic

	_install_pip3 mycli


	if ! type -P composer &>/dev/null; then
		# shellcheck disable=SC2091
		curl -sSL https://getcomposer.org/installer | $(command -v php) && sudo -E mv composer.phar /usr/local/bin/composer
	fi


	if ! type -P phive &>/dev/null; then
		cd /tmp
		wget -O phive.phar https://phar.io/releases/phive.phar
		wget -O phive.phar.asc https://phar.io/releases/phive.phar.asc
		gpg --keyserver pool.sks-keyservers.net --recv-keys 0x9D8A98B29B2D5D79
		gpg --verify phive.phar.asc phive.phar
		chmod +x phive.phar
		sudo -E mv phive.phar /usr/local/bin/phive
	fi

	# @see https://github.com/felixfbecker/php-language-server/issues/611
	sudo -E composer global require jetbrains/phpstorm-stubs:dev-master
	sudo -E composer global require felixfbecker/language-server
	# run once: composer global run-script --working-dir="$HOME/.composer/vendor/felixfbecker/language-server" parse-stubs


	sudo -E phive install -g --trust-gpg-keys squizlabs/php_codesniffer  
	sudo -E phive install -g --trust-gpg-keys phpstan/phpstan

	# shellcheck disable=SC2091
	# curl -sSL https://litipk.github.io/Jupyter-PHP-Installer/dist/jupyter-php-installer.phar > "${TMPDIR}/jupyter.php"
	# sudo -E $(command -v php) "${TMPDIR}/jupyter.php" install
	# rm "${TMPDIR}/jupyter.php"

	# xdebug
	sudo -E ufw allow 9000/udp
	sudo -E ufw allow 9000/tcp
	sudo -E ufw reload
}


function docker() {
	unset -f docker
	_remove docker.io docker
	_install apt-transport-https \
		ca-certificates \
		curl \
		gnupg2 \
		software-properties-common \
		qemu-user-static \
		lxcfs \
		uidmap

	# if ! type -P ctop &>/dev/null; then
		# sudo -E curl -sSL "https://github.com/bcicen/ctop/releases/download/v0.7.2/ctop-0.7.2-linux-$(cpu_architecture_simple)" -o /usr/local/bin/ctop
		# sudo -E chmod +x /usr/local/bin/ctop
	# fi

	
	if ! type -P docker &>/dev/null; then
		curl -sSL https://download.docker.com/linux/ubuntu/gpg | sudo -E apt-key add -
		sudo -E apt-key fingerprint 0EBFCD88
		sudo -E add-apt-repository \
			"deb [arch=$(cpu_architecture_simple)] https://download.docker.com/linux/ubuntu \
			$(lsb_release -cs) \
			stable"
		_force_update
		_install docker-ce
	fi
		sudo -E usermod -aG "docker" "$(whoami)"

	# if ! type -P docker-compose &>/dev/null; then
		# sudo -E curl -sSL "https://github.com/docker/compose/releases/download/1.27.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
		# sudo -E chmod +x /usr/local/bin/docker-compose
	# fi
	_install_pip3 docker-compose

	# if ! type -P dockerize &>/dev/null; then
	# 	sudo -E curl -sSL "https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-$(cpu_architecture_simple)-v0.6.1.tar.gz" -o /usr/local/bin/dockerize
	# 	sudo -E chmod +x /usr/local/bin/dockerize
	# fi

	# if ! type -P docker-machine &>/dev/null; then
	# 	base=https://github.com/docker/machine/releases/download/v0.16.2
	#   	curl -sSL "$base/docker-machine-$(uname -s)-$(uname -m)" >/tmp/docker-machine
	#   	sudo mv /tmp/docker-machine /usr/local/bin/docker-machine
	#   	sudo chmod +x /usr/local/bin/docker-machine
	# fi

	if [[ -n $ROOT_DIR ]] && [[ -f "$ROOT_DIR/etc/docker/daemon.json" ]]; then
		sudo -E cp "$ROOT_DIR/etc/docker/daemon.json" /etc/docker/daemon.json
	fi

	# if which podman &>/dev/null
	# then
	# 	# Podman
	# 	_update
	# 	sudo -E apt -y install software-properties-common
	# 	_add_repository ppa:projectatomic/ppa
	# 	sudo -E apt install podman -y
	# fi

	cd "${TMPDIR}"
	# if ! type -P lazydocker &>/dev/null; then
	# 	curl -sSL "https://github.com/jesseduffield/lazydocker/releases/download/v0.7.1/lazydocker_0.7.1_Linux_$(cpu_architecture).tar.gz" > lazydocker.tgz
	# 	tar xzf lazydocker.tgz
	# 	sudo -E install lazydocker /usr/local/bin/
	# fi

	# if ! type -P dry &>/dev/null; then
		# curl -sSf https://moncho.github.io/dry/dryup.sh | sudo sh
		# sudo chmod 755 /usr/local/bin/dry
	# fi

	# Docker rootless
	# curl -LsS https://get.docker.com/rootless | FORCE_ROOTLESS_INSTALL=1 DOCKER_BIN=$HOME/docker bash  
	# systemctl --user start docker
	# export PATH=/home/mandy/docker:$PATH
	# export DOCKER_HOST=unix:///run/user/1000/docker.sock

}

function polybar() {
	unset -f polybar
	sudo snap install polybar-git --edge
	return
	declare -a packages=()
	packages+=(build-essential git cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev)
	packages+=(libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev)
	_install "${packages[*]}" 
	cd "${TMPDIR}"
	git clone -q https://github.com/jaagr/polybar.git
	cd polybar && ./build.sh --all-features --gcc --install-config --auto
}


function networkmanager() {
	LINE="source /etc/network/interfaces.d/*"
	FILE=/etc/network/interfaces
	grep -qF -- "$LINE" "$FILE" &>/dev/null|| echo "$LINE" | sudo -E tee -a "$FILE"
	sudo -E mkdir -p /etc/network/interfaces.d

		sudo -E tee /etc/NetworkManager/conf.d/00-use-dnsmasq.conf << EOL &>/dev/null
# This enabled the dnsmasq plugin.
[main]
dns=dnsmasq
EOL

	sudo -E rm -f /etc/NetworkManager/dnsmasq.d/00-home-mndy-be.conf
	sudo -E rm -f /etc/NetworkManager/dnsmasq.d/00-nextdns.conf


	sudo -E tee /etc/NetworkManager/conf.d/00-ignore-docker-and-vbox.conf << EOL &>/dev/null
[keyfile]
unmanaged-devices=interface-name:docker0;interface-name:vboxnet*;interface-name:br-*;interface-name:veth*;interface-name:docker_gwbridge
EOL

	# use network manager instead of systemd resolve resolv.conf
	if [[ -f /var/run/NetworkManager/resolv.conf ]]; then
		sudo -E rm /etc/resolv.conf
		sudo -E ln -s /var/run/NetworkManager/resolv.conf /etc/resolv.conf
	fi
	sudo -E systemctl restart NetworkManager
}

function sysctl() {
	unset -f sysctl
	# @todo add https://askubuntu.com/questions/23674/netbook-freezes-with-high-load-on-every-io-operation to sysctl if IO performance is a problem
	sudo -E tee /etc/sysctl.d/mandy.conf << EOL &>/dev/null
# Virtual IPs
net.ipv4.ip_nonlocal_bind=1

# For IntelliJ products for example
# See https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
fs.inotify.max_user_watches=524288

net.ipv4.ip_forward=1
kernel.printk=2 4 1 7

# See https://success.docker.com/article/node-using-swap-memory-instead-of-host-memory
vm.swappiness=0
vm.overcommit_memory=1


vm.max_map_count=262144
# Do not produce core dumps
fs.suid_dumpable=0

net.bridge.bridge-nf-call-ip6tables = 0
net.bridge.bridge-nf-call-iptables = 0
net.bridge.bridge-nf-call-arptables = 0
# Docker rootless
kernel.unprivileged_userns_clone=1
EOL

	sudo -E tee /etc/sysctl.d/mandy-keepalive.conf << EOL &>/dev/null
net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_keepalive_intvl = 5
net.ipv4.tcp_keepalive_probes = 3
EOL

	sudo -E tee /etc/security/limits.d/99-no-core-dumps.conf << EOL &>/dev/null
* hard core 0
EOL

	sudo "sysctl" --system >/dev/null
}

function firewall() {
	sudo -E ufw enable
	sudo -E ufw allow ssh

	# nomachine
	sudo -E ufw allow 4000/udp
	sudo -E ufw allow 4000/tcp

	sudo -E ufw reload

}

function git-config() {
	git config --global --replace-all submodule.recurse true
	git config --global --replace-all user.name 'Mandy Schoep'
	git config --global --replace-all fetch.prune true
	git config --global --replace-all diff.guitool meld
	echo "Manually execute 'git config --global user.email <email>'"
}

function ibus_config() {
	dconf write /desktop/ibus/general/hotkey/triggers "['<Super>i']"
	dconf write /desktop/ibus/general/preload-engines "['xkb:us:altgr-intl:eng']"
	# dconf write /desktop/ibus/general/version "'1.5.17'"
	dconf write /desktop/ibus/panel/emoji/font "'Noto Color Emoji 16'"
	dconf write /desktop/ibus/panel/show 2
}

function autostart() {
	mkdir -p ~/.config/autostart

	ln -s "${ROOT_DIR}"/.config/autostart/*.desktop ~/.config/autostart/ 2>/dev/null || true

	ln -sf /usr/share/applications/ulauncher.desktop ~/.config/autostart/ || true
	ln -sf /usr/share/applications/redshift-gtk.desktop ~/.config/autostart/ || true
	ln -sf /usr/share/applications/nextcloud.desktop ~/.config/autostart/ || true
	ln -sf /usr/share/applications/clipit.desktop ~/.config/autostart/ || true
	rm -r ~/.config/autostart/tilda.desktop 2>/dev/null || true
	# shellcheck disable=SC1073,SC2181
	if glxinfo | grep -i "accelerated: no" &>/dev/null; then
		_install_if_not_installed compton
		ln -sf "$ROOT_DIR/.local/share/applications/Compton.desktop" ~/.config/autostart/
	fi
	find ~/.config/autostart/ -xtype l -delete
	sudo -E update-desktop-database
}

function _install_if_not_installed() {
	if ! command -v "$1" &>/dev/null; then
		_install "$1"
	fi
}

function audit() {
	_install "auditd"
	sudo curl -Lss https://raw.githubusercontent.com/Neo23x0/auditd/3082efe116292a2e2b59b0acc171a74bccc38d90/audit.rules -o /etc/audit/rules.d/audit.rules
	sudo augenrules --load
}


function wine() {
	packages+=(wine winetricks)
	_install "${packages[*]}" 
}

function gaming() {
	lutris
	retroarch-config
	packages+=(steam)

	_install https://launcher.mojang.com/download/Minecraft.deb

	_install "${packages[*]}" 
	
	pipx install protontricks
}

## Gaming section
function lutris() {
	unset -f lutris
	_add_repo_or_install_deb 'ppa:lutris-team/lutris' 'lutris'
}

function install-game-roms() {
	if [[ ! -d ~/Games/bios ]]; then
		cd "${TMPDIR}"
		curl -sSL https://archive.org/download/retropiebiosfilesconfiguredforeverysystem_20190904/Retropie%20Bios%20Files%20Configured%20for%20Every%20System.zip > bios.zip
		mkdir -p ~/Games/bios
		cd ~/Games/bios
		unzip "${TMPDIR}/bios.zip"
		mv Retropie\ Bios\ Files\ Configured\ for\ Every\ System/** .
		rm -rf Retropie\ Bios\ Files\ Configured\ for\ Every\ System
		rm "${TMPDIR}/bios.zip"
	fi
	# shellcheck disable=SC2046
	cp -r ~/Games/bios/BIOS/** $(_retroarch_system_folders)
}

function retroarch() {
	_add_repository ppa:libretro/stable
	_install 'retroarch*'
}

function retroarch-config() {
	# @todo add bios files to the system directories

	_set_retroarch_config menu_swap_ok_cancel_buttons "\"true\""
	_set_retroarch_config fps_show "\"true\""
	_set_retroarch_config menu_show_core_updater "\"true\""
	_set_retroarch_config system_directory "\"/tank/media/games/retropie/bios/\""
	
	# shellcheck disable=SC2016
	crudini --set --inplace "{}" "" system_directory "/tank/media/games/bios"
		

	_set_retroarch_coreconfig beetle_psx_dither_mode "\"internal resolution\""
	_set_retroarch_coreconfig beetle_psx_filter "\"bilinear\""
	_set_retroarch_coreconfig beetle_psx_internal_color_depth "\"32bpp\""
	_set_retroarch_coreconfig beetle_psx_internal_resolution "\"8x\""
	_set_retroarch_coreconfig beetle_psx_renderer "\"vulkan\""
	_set_retroarch_coreconfig beetle_psx_scale_dither "\"enabled\""
}

function _retroarch_system_folders() {
	# shellcheck disable=SC2016
	find ~/.config ~/snap ~/.local/share -type f -name 'retroarch.cfg' -and -not -wholename '*/Trash/*' -print0 \
	 	| xargs -0 -r -i bash -c 'mkdir -p "$(dirname "{}")/system"; echo "$(dirname "{}")/system"'
}

retroarch_config_files=""
function _set_retroarch_config() {
	if [[ $retroarch_config_files = '' ]]; then
		retroarch_config_files=$(find ~/.config ~/snap ~/.local/share -type f -name 'retroarch.cfg' -and -not -wholename '*/Trash/*')
	fi
	# create system folders
	# shellcheck disable=SC2016
	echo _retroarch_system_folders | xargs -0 -r -i bash -c 'mkdir -p "$(dirname "{}")/system"'

	local key="$1"
	local value="$2"
	echo "$retroarch_config_files" | xargs -r -i crudini --set --inplace "{}" '' "$key" "$value"
}

retroarch_core_config_files=""
function _set_retroarch_coreconfig() {
	if [[ $retroarch_core_config_files == '' ]]; then
		retroarch_core_config_files=$(find ~/.config ~/snap ~/.local/share -type f -name 'retroarch-core-options.cfg' -and -not -wholename '*/Trash/*')
	fi
	local key="$1"
	local value="$2"
	echo "$retroarch_core_config_files" \
		| xargs -r -i crudini --set --inplace "{}" '' "$key" "$value"
}

function fail() {
	exit 233
}


for function in "$@"
do
	function="${function//--/}"
    echo "Executing $function"
	$function
done