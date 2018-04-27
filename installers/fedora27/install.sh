#!/usr/bin/env bash



# tab width
tabs 4
clear

# Title of script set
TITLE="Fedora Post-Install Script"

# Main
function main {
	echo_message header "Starting 'main' function"
	# Draw window
	MAIN=$(eval `resize` && whiptail \
		--notags \
		--title "$TITLE" \
		--menu "\nWhat would you like to do?" \
		--cancel-button "Quit" \
		$LINES $COLUMNS $(( $LINES - 12 )) \
		'system_update'			'Perform system update' \
		'all'		            'Install all packages' \
		'multimedia'		    'Install multimedia packages' \
		'virtualization'        'Install virtualization packages' \
		'wine'                  'Install wine packages' \
		3>&1 1>&2 2>&3)
	# check exit status
	if [ $? = 0 ]; then
		echo_message header "Starting '$MAIN' function"
		$MAIN
	else
	    exit 0
	fi
}


# Fancy colorful echo messages
function echo_message(){
	local color=$1;
	local message=$2;
	if ! [[ $color =~ '^[0-9]$' ]] ; then
		case $(echo -e $color | tr '[:upper:]' '[:lower:]') in
			# black
			header) color=0 ;;
			# red
			error) color=1 ;;
			# green
			success) color=2 ;;
			# yellow
			welcome) color=3 ;;
			# blue
			title) color=4 ;;
			# purple
			info) color=5 ;;
			# cyan
			question) color=6 ;;
			# orange
			warning) color=202 ;;
			# white
			*) color=7 ;;
		esac
	fi
	tput bold;
	tput setaf $color;
	echo '-- '$message;
	tput sgr0;
}


function base {
    add_repositories


    cat <<'EOL' | sed '/^$/d'| xargs -I {} sudo dnf install -y {}
@core
@standard
@hardware-support
@base-x
@firefox
@fonts
@multimedia
@networkmanager-submodules
@printing
@development-tools
vim
NetworkManager-openvpn-gnome
dnf-plugins-core

redhat-rpm-config
rpmconf
htop

google-chrome-stable
calc
gitflow

strace
system-config-printer

i3
i3lock
xterm
zsh
google-roboto-fonts
redshift
unzip
openssh
arandr
lxappearance
parcellite
byobu
tmux
network-manager-applet
feh
xsel
xclip
variety
paper-icon-theme
yad
thunar
file-roller
unrar
evince
git
tig
ruby
ruby-devel


synergy
pulseaudio

gnome-disk-utility

gedit
gedit-plugins
lightdm
xfce4-panel
xfce4-power-manager
virt-what

jq
ImageMagick

numix-gtk-theme
arc-theme
dmz-cursor-themes

shotwell
gnupg
openssl-devel
gcc-c++
make
neofetch
xfce4-terminal

pasystray
glibc-locale-source
freetype-freeworld
wget
vpnc

dnfdragora
seahorse
gnome-keyring
curl
sqlite

openssh-askpass
shutter
hunspell-en
hunspell-nl

gnome-python2-gconf
qdirstat
font-manager
libXt-devel
libXfixes-devel
libXi-devel


keepassxc
qt5ct
qt-config
qt5-qtstyleplugins
exa
compton
java-1.8.0-openjdk

imwheel

fuse
cifs-utils
gvfs-fuse
fuse-exfat
fuse-sshfs
exfat-util

rofi

vlc
EOL

    sudo localedef -i nl_BE -f UTF-8 nl_BE.UTF-8
    cat <<'EOL' | sudo tee /etc/locale.conf
LANG=en_US.UTF-8
LANGUAGE="en_US.UTF-8"
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC="nl_BE.UTF-8"
LC_TIME="nl_BE.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_MONETARY="nl_BE.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_PAPER="nl_BE.UTF-8"
LC_NAME="nl_BE.UTF-8"
LC_ADDRESS="nl_BE.UTF-8"
LC_TELEPHONE="nl_BE.UTF-8"
LC_MEASUREMENT="nl_BE.UTF-8"
LC_IDENTIFICATION="nl_BE.UTF-8"

EOL

    cat <<'EOL' | sudo tee /etc/fonts/local.conf
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
<match target="font">
    <edit name="antialias" mode="assign">
        <bool>true</bool>
    </edit>
    <edit name="autohint" mode="assign">
        <bool>false</bool>
    </edit>
    <edit name="hinting" mode="assign">
        <bool>true</bool>
    </edit>
    <edit name="hintstyle" mode="assign">
        <const>hintslight</const>
    </edit>
    <edit name="lcdfilter" mode="assign">
        <const>lcddefault</const>
    </edit>
    <edit name="rgba" mode="assign">
        <const>rgb</const>
    </edit>
    <edit name="embeddedbitmap" mode="assign">
        <bool>false</bool>
    </edit>
</match>
</fontconfig>
EOL

    cat <<'EOL' | sudo tee /etc/sysctl.conf
# sysctl settings are defined through files in
# /usr/lib/sysctl.d/, /run/sysctl.d/, and /etc/sysctl.d/.
#
# Vendors settings live in /usr/lib/sysctl.d/.
# To override a whole file, create a new file with the same in
# /etc/sysctl.d/ and put new settings there. To override
# only specific settings, add a file with a lexically later
# name in /etc/sysctl.d/ and put new settings there.
#
# For more information, see sysctl.conf(5) and sysctl.d(5).

# For IntelliJ products for example
# See https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
fs.inotify.max_user_watches = 524288
net.ipv4.ip_forward=1

EOL

# @todo https://coderwall.com/p/66kbaw/adding-entries-to-resolv-conf-on-fedora
    cat <<'EOL' | sudo tee /etc/resolvconf/resolv.conf.d/base
nameserver 1.1.1.1
nameserver 1.0.0.1
EOL



    sudo gem install json
    sudo gem install rdoc
    sudo gem install teamocil

    sudo pip3 install udiskie

    # install polybar
    sudo dnf install -y cmake @development-tools gcc-c++ i3-ipc jsoncpp-devel pulseaudio-libs-devel alsa-lib-devel wireless-tools-devel libmpdclient-devel libcurl-devel cairo-devel xcb-proto xcb-util-devel xcb-util-wm-devel xcb-util-image-devel
    sudo dnf install -y pulseaudio-libs-devel xcb-util-xrm-devel
    rm -rf /tmp/polybar
    git clone --recursive https://github.com/jaagr/polybar /tmp/polybar
    cd /tmp/polybar
    mkdir build
    cd build
    cmake ..
    sudo make install
    # end install Polybar


    sudo usermod -a -G docker mandy
    sudo groupadd power
    sudo usermod -a -G power mandy
    sudo usermod -a -G disk mandy
    sudo chsh -s /bin/zsh mandy


    sudo bash ~/dotfiles/installers/jetbrains-toolbox.sh
    sudo bash ~/dotfiles/installers/xbanish.sh
    sudo bash ~/dotfiles/installers/purevpn.sh

    sudo systemctl enable lightdm
    sudo systemctl start firewalld
    virt-what | grep -q -i virtualbox && sudo dnf install -y VirtualBox-guest-additions

    sudo dnf install -y https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm
    sudo dnf install -y http://download.nomachine.com/download/6.0/Linux/nomachine_6.0.78_1_x86_64.rpm
    sudo dnf install -y http://rpmfind.net/linux/mageia/distrib/cauldron/x86_64/media/core/release/dunst-1.3.1-1.mga7.x86_64.rpm


    # Create swap file
    # create_swap_file 4 /swapfile
    # echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
}

function setup_firewall {
    sudo firewall-cmd --zone=public --permanent --add-service=http
    sudo firewall-cmd --zone=public --permanent --add-service=https
    sudo firewall-cmd --zone=public --permanent --add-service=mysql
}

function add_repositories {
    # Persist extra repos and import keys.
    cat << EOF | sudo tee /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

    sudo rpm --import https://dl-ssl.google.com/linux/linux_signing_key.pub

    sudo rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-27.noarch.rpm
    sudo rpm -ivh http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-27.noarch.rpm
    sudo rpm -ivh https://rpms.remirepo.net/fedora/remi-release-27.rpm
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install http://mirror.yandex.ru/fedora/russianfedora/russianfedora/free/fedora/releases/27/Everything/x86_64/os/russianfedora-free-release-27-1.noarch.rpm  -y
    sudo dnf install $(curl -s https://api.github.com/repos/saenzramiro/rambox/releases/latest | jq -r ".assets[] | select(.name) | select(.browser_download_url | test(\"64.*rpm$\")) | .browser_download_url") -y
    sudo dnf install https://www.rpmfind.net/linux/sourceforge/u/un/unitedrpms/27/x86_64/msttcorefonts-2.5-4.fc27.noarch.rpm -y
    sudo dnf config-manager --set-enabled remi-php72
    sudo dnf copr enable yaroslav/i3desktop -y
    sudo rpm --import https://dl.tvcdn.de/download/linux/signature/TeamViewer2017.asc
}

function system_update {
    sudo dnf update -y --refresh
}



function all {
    base
    multimedia
    virtualization
    wine
    openbox
    cinnamon
    networkutilities
    development
    system_update
}

function multimedia {
    # Audio
    sudo dnf install -y ffmpeg flacon shntool cuetools
    sudo dnf install -y mpc mpd rhythmbox
    # Photo
    sudo dnf install -y gimp darktable

    # Video
    sudo dnf install -y vlc

    sudo dnf install -y @multimedia
}

function virtualization {
    sudo dnf install -y VirtualBox
}

function wine {
    sudo dnf install -y wine playonlinux
}


function openbox {
    sudo dnf install -y openbox openbox-theme-mistral-thin openbox-theme-mistral-thin-dark obconf
}

function cinnamon {
    sudo dnf install -y cinnamon-desktop
}

function networkutilities {
    sudo dnf install -y nmap tcpdump ncdu

}

function development {
    sudo dnf install -y docker-ce docker-compose
    sudo systemctl enable docker

    sudo dnf install -y meld filezilla shellcheck
    # PHP
    sudo dnf install -y composer php-pecl-imagick
    
    sudo pip3 install mycli
    sudo pip3 install httpie
    
    # The fuck
    sudo dnf install -y python3-devel
    sudo pip3 install thefuck
    
    
        
    # Install Dry, 
    # dry is a terminal application to manage and monitor Docker containers.
    # See https://moncho.github.io/dry/
    sudo curl -sSf https://moncho.github.io/dry/dryup.sh | sh
    sudo chmod 755 /usr/local/bin/dry
    sudo chmod +x /usr/local/bin/dry
    
    


    # Sublime text
    # sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
    # sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
    # sudo dnf install sublime-text -y

    
    composer global require "acacha/llum"
    composer global require "acacha/adminlte-laravel-installer"
    composer global require "symfony/console"
    composer global require "jolicode/jolinotif"
    composer global require "squizlabs/php_codesniffer"
    
    
    # Atom
#    sudo dnf install -y $(curl -sL "https://api.github.com/repos/atom/atom/releases/latest" | grep "https.*atom.x86_64.rpm" | cut -d '"' -f 4)

}
# Welcome message
echo_message welcome "$TITLE"

if [ "$1" != '' ]; then
    $1
fi
# main
while :
do
	main
done