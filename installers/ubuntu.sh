#!/usr/bin/env bash

if [[ $UID -eq 0 ]]; then
	echo "Run this script as non root user please..."
	exit 99
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
cd "$DIR" || exit 1

set -e

###############
## getopt
###############

# @todo make this autodetectable
CPU_ARCHITECTURE=amd64

function usage() {
	echo
	echo "Usage: $0 [ARGS...]" 1>&2
	echo
	echo "Options:"
	echo "      --dev							Install dev packages"
	echo "      --link							Link dotfiles"
	echo "      --base							Install bare minimum packages"
	echo "      --sysctl							Configure sysctl"
	echo "      --services						Install necessary systemd services"
	echo "      --ulauncher						Install ulauncher"
	echo "      --multimedia						Install multimedia"
	echo "      --communications						Install discord etc."
	echo "      --git-config						Configure git"
	echo "      --quicktile						Install quicktile"
	echo "      --docker							Install docker"
	echo "      --fonts							Install fonts"
	echo "      --zsh							Install and configure zsh"
	echo "      -v|--verbose						Verbose output"
	echo "      -h, --help						Print this help"
}

options=$(getopt -o "hv" --longoptions "base,help,sysctl,services,ulauncher,verbose,zsh,quicktile,communications,git-config,docker,dev,link,fonts,multimedia" -- "$@")
eval set -- "$options"

apt_quiet="-qq"
while true; do
	case "$1" in
	-h | --help)
		usage
		exit 0
		;;
	-v | --verbose)
		set -x
		apt_quiet=""
		;;
	--)
		shift
		break

		;;
	esac
	shift
done

###############
## end getopt
###############

###
# Util functions
####
{
	function _install() {
		# shellcheck disable=SC2068
		sudo -E apt-get $apt_quiet install -y $@
	}

	function _install_flatpak_flathub() {
		if ! command -v flatpak &>/dev/null; then
			_install flatpak
		fi

		yes | sudo -E flatpak remote-add --if-not-command -v flathub https://flathub.org/repo/flathub.flatpakrepo --system &>/dev/null
		sudo -E flatpak install flathub "$*" --system -y
	}

	function _install_pip3() {
		if ! command -v pip3 &>/dev/null; then
			_install python3-pip
		fi
		# shellcheck disable=SC2068
		python3 -m pip install --user $@ >/dev/null
	}

	function _install_pipx() {
		if ! command -v pipx &>/dev/null; then
			_install_pip3 pipx
		fi
		if ! python3 -m venv -h &>/dev/null; then
			_install python3-venv
		fi
		pipx ensurepath &>/dev/null
		echo "$@" | tr -d '\n' | xargs -d' ' -r -i sudo -E pip3 uninstall -q -y {} &>/dev/null | true
		echo "$@" | tr -d '\n' | xargs -d' ' -r -i python3 -m pip uninstall --user -q -y {} &>/dev/null | true
		# shellcheck disable=SC2068
		echo "$@" | tr -d '\n' | xargs -d' ' -r -i pipx install {} --include-deps --pip-args="-q --force" >/dev/null
	}

	function _install_snap() {
		if ! command -v snap &>/dev/null; then
			_install snapd
		fi
		# shellcheck disable=SC2068
		sudo -E snap install $@
	}

	function _install_pip() {
		if ! command -v pip &>/dev/null; then
			_install python-pip
		fi
		# shellcheck disable=SC2068
		sudo -E pip install -q $@
	}

	function _install_gem() {
		if ! command -v gem &>/dev/null; then
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

	function _install_deb_from_url() {
		local url="$1"
		local tmp="$(mktemp)"
		if ! command -v curl &>/dev/null; then
			_install curl
		fi
		curl -sSL "$url" >>"$tmp"
		sudo -E dpkg -i "$tmp" || true
		sudo -E apt-get $apt_quiet install -f -y
	}

	function _is_x_package() {
		{
			set +e
			sudo -E apt-rdepends "$*" 2>/dev/null | grep 'Depends: libx11' &>/dev/null
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
			sudo -E add-apt-repository -y "$repo"
			_install "$package_name"
		fi

		# still no package?? remove repo and install deb
		if ! command -v "$package_name" &>/dev/null; then
			sudo -E add-apt-repository -y --remove "$repo"
			if [[ $optional_deb != '' ]]; then
				_install_deb_from_url "$optional_deb"
				sudo -E apt-get $apt_quiet install -f -y
			fi
		fi
	}

	fontsAdded=0
	function __installFontsFromZip() {
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
			__deleteWindowsFonts
		fi
	}

	function __deleteWindowsFonts() {
		if [ "$(uname)" = 'Darwin' ]; then
			local DIR=~/Library/Fonts
		else
			local DIR=~/.local/share/fonts
		fi
		find $DIR -iname '*windows*' -exec rm -r "{}" \;
	}

}
###
# End Util functions
####

################
# Functions
################

function _minimum() {
	_install curl wget sudo
}

function _base() {
	_install git tree zsh tmux htop vim

	_install nmap iputils-ping dnsutils sed grep file

	if [[ "$DISPLAY" != "" ]]; then
		_install xclip xsel syncthing-gtk
		_install_snap bitwarden
		if ! command -v vivaldi &>/dev/null; then
			_install_deb_from_url https://downloads.vivaldi.com/stable/vivaldi-stable_5.0.2497.32-1_amd64.deb
		fi

		if [[ "$GNOME_SHELL_SESSION_MODE" != '' ]]; then
			_install gnome-tweaks
		fi
	fi

	_install_snap code --classic

}

function _communications() {
	_install_snap discord
	_install_snap skype
	_install_snap signal-desktop
	_install_snap zoom-client
}

function _multimedia() {
	# foliate is an ebook reader
	_install_snap foliate
	_install_snap spotify

	_install pavucontrol
}

function _docker() {
	_remove docker.io docker
	_install apt-transport-https \
		ca-certificates \
		curl \
		gnupg2 \
		software-properties-common \
		qemu-user-static \
		lxcfs \
		uidmap

	if ! command -v docker &>/dev/null; then
		curl -sSL https://download.docker.com/linux/ubuntu/gpg | sudo -E apt-key add -
		sudo -E apt-key fingerprint 0EBFCD88
		sudo -E add-apt-repository \
			"deb [arch=$CPU_ARCHITECTURE] https://download.docker.com/linux/ubuntu \
			$(lsb_release -cs) \
			stable"
		_force_update
		_install docker-ce
	fi
	sudo -E usermod -aG "docker" "$(whoami)"

	if ! command -v docker-compose &>/dev/null; then
		sudo -E curl -sSL "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
		sudo -E chmod +x /usr/local/bin/docker-compose
	fi

	if [[ -f "$DIR/etc/docker/daemon.json" ]] && [[ ! -f /etc/docker/daemon.json ]]; then
		sudo -E cp "$DIR/etc/docker/daemon.json" /etc/docker/daemon.json
	fi

}

function _link() {

	"$DIR/link.sh"

}

function _dev() {
	_install_snap multipass
	_install virt-manager

	_install_snap jq
	_install_snap yq
	_install_snap kubectl --classic

	if ! command -v minikube &>/dev/null; then
		# minikube start --kubernetes-version=v1.19.16 --driver=docker
		_install_deb_from_url https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
	fi

	if ! grep --quiet releases.hashicorp.com /etc/apt/sources.list &>/dev/null; then
		curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
		sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
		_force_update
	fi
	_install vault terraform

	_docker

	_install shellcheck yamllint
}

function _ulauncher() {
	_add_repo_or_install_deb 'ppa:agornostal/ulauncher' 'ulauncher' 'https://github.com/Ulauncher/Ulauncher/releases/download/5.7.4/ulauncher_5.7.4_all.deb'
}

function _zsh() {
	_install zsh
	bash "$DIR/installers/apps/oh-my-zsh.sh"
	# Fix for snaps with ZSH
	LINE="emulate sh -c 'source /etc/profile'"
	FILE=/etc/zsh/zprofile
	grep -qF -- "$LINE" "$FILE" || echo "$LINE" | sudo -E tee "$FILE" >/dev/null
	sudo -E chsh -s "$(command -v zsh)" "$(whoami)"
}

function _quicktile() {
	declare -a packages=()
	# Window managing
	# quicktile dependencies
	packages+=(python3 python3-pip python3-setuptools python3-gi python3-xlib python3-dbus gir1.2-glib-2.0 gir1.2-gtk-3.0 gir1.2-wnck-3.0)

	_install "${packages[*]}"
	# _install_deb_from_url "http://ftp.nl.debian.org/debian/pool/main/g/gnome-python-desktop/python-wnck_2.32.0+dfsg-3_$(cpu_architecture_simple).deb"
	_install_pip3 https://github.com/ssokolow/quicktile/archive/master.zip

}
function _services() {
	sudo cp "$DIR/services/apple-keyboard.service" /etc/systemd/system/apple-keyboard.service

	sudo systemctl daemon-reload
	sudo systemctl enable --now apple-keyboard
}

function _sysctl() {
	# @todo add https://askubuntu.com/questions/23674/netbook-freezes-with-high-load-on-every-io-operation to sysctl if IO performance is a problem
	sudo -E tee /etc/sysctl.d/mandy.conf <<EOL &>/dev/null
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

	sudo -E tee /etc/sysctl.d/mandy-keepalive.conf <<EOL &>/dev/null
net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_keepalive_intvl = 5
net.ipv4.tcp_keepalive_probes = 3
EOL

	sudo -E tee /etc/security/limits.d/99-no-core-dumps.conf <<EOL &>/dev/null
* hard core 0
EOL

	# * Applying /usr/lib/sysctl.d/50-default.conf ...
	# net.ipv4.conf.default.promote_secondaries = 1
	# sysctl: setting key "net.ipv4.conf.all.promote_secondaries": Invalid argument
	sudo sysctl --system >/dev/null
}

function _firewall() {
	sudo -E ufw enable
	sudo -E ufw allow ssh

	# nomachine
	sudo -E ufw allow 4000/udp
	sudo -E ufw allow 4000/tcp

	sudo -E ufw reload

}

function _git-config() {
	git config --global --replace-all submodule.recurse true
	git config --global --replace-all user.name 'Mandy Schoep'
	git config --global --replace-all fetch.prune true
	git config --global --replace-all diff.guitool meld
	echo "Manually execute 'git config --global user.email <email>'"
}

function _fonts() {
	__installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/SourceCodePro.zip SourceCodeProNerdFont
	__installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FantasqueSansMono.zip FantasqueSansMono
	__installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip DroidSansMono
	__installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DejaVuSansMono.zip DejaVuSansMono
	__installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Iosevka.zip Iosevka
	__installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Inconsolata.zip Inconsolata
	__installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip JetBrainsMono
	__installFontsFromZip https://github.com/IBM/plex/releases/download/v4.0.2/OpenType.zip "IBM Plex"

	if [[ $fontsAdded -eq 1 ]]; then
		fc-cache -f -v
	fi
}

################
# End Functions
################

_minimum

for function in $options; do
	function="${function//--/}"
	if declare -f -F "_$function" &>/dev/null; then
		echo "Executing $function"
		"_$function"
	fi
done
