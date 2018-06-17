#!/usr/bin/env bash

if [ $UID -ne 0 ]; then
    echo "Run this script as root user please..."
    exit 99
fi

HOME=/home/mandy
USER=mandy

if [ $HOME != '/home/mandy' ]; then
    echo "\$HOME is not '/home/mandy' ($HOME)"
    exit 100
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
		'developer_tools'       'Install developer tools packages' \
		'development'           'Install development packages' \
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

    setup_custom_services
set -e
    cat <<'EOL' | sed '/^$/d' | xargs -I {} sh -c 'echo "installing: {}"; dnf install -y >/dev/null {}'
@core
@standard
@hardware-support
@base-x
@firefox
@xfce
@fonts
terminus-fonts-console
fontconfig-enhanced-defaults
fontconfig-font-replacements

@multimedia
@networkmanager-submodules
@printing
@development-tools
byzanz
vim
NetworkManager-openvpn-gnome
dnf-plugins-core

redhat-rpm-config
dnf-plugin-system-upgrade
rpmconf
htop
iotop

google-chrome-stable
mate-calc
gitflow

strace
system-config-printer

i3
i3lock
wmctrl
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
tumbler
nemo
unrar
engrampa
git
tig
ruby
ruby-devel


synergy
pulseaudio

gnome-disk-utility

pluma
gedit
lightdm
xfce4-panel
xfce4-power-manager
virt-what

jq
ImageMagick

numix-gtk-theme
arc-theme
dmz-cursor-themes

ristretto
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
exfat-utils

atril
rofi

vlc

gnuplot
ncmpcpp

system-config-kickstart
mediawriter
xss-lock
libvirt
sysstat
albert

openvpn
pykickstart

sublime-text
xbacklight
xfce4-notifyd
grsync
EOL
    status=$?
    if [ $status -ne 0 ]; then
        echo "Install exited with status ${status}"
        exit 2
    fi
    dnf remove gnome-calculator evince file-roller gedit gedit-plugins gnucash -y

    su mandy bash -c "rm -rf ~/.gemrc; ln -sf ${DIR}/../../.gemrc ~/.gemrc"

    su mandy bash -c 'gem install json'
    su mandy bash -c 'gem install teamocil'

    pip3 install udiskie

    # Fixes for pulseaudio
    sed -E -i 's#.*autospawn.*#autospawn = yes#g' /etc/pulse/client.conf
    pulseaudio -D

    # install cli-visualizer
    cd /tmp
    dnf install -y fftw-devel ncurses-devel pulseaudio-libs-devel
    rm -rf /tmp/cli-visualizer
    git clone --recursive https://github.com/dpayne/cli-visualizer.git /tmp/cli-visualizer
    cd /tmp/cli-visualizer
    ./install.sh
    # end install cli-visualizer


    # install xrectsel
    which xrectsel >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        dnf install autoconf automake -y
        bash ~/dotfiles/installers/install-xrectsel.sh
    fi


    usermod -a -G docker mandy
    groupadd power
    usermod -a -G power mandy
    usermod -a -G disk mandy
    chsh -s /bin/zsh mandy


    which jetbrains-toolbox >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        bash $HOME/dotfiles/installers/jetbrains-toolbox.sh
    fi

    which xbanish >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        bash $HOME/dotfiles/installers/xbanish.sh
    fi

    which purevpn >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        bash $HOME/dotfiles/installers/purevpn.sh
    fi

    systemctl enable lightdm
    systemctl start firewalld
    virt-what | grep -q -i virtualbox && dnf install -y VirtualBox-guest-additions

    dnf install -y https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm
    dnf install -y http://download.nomachine.com/download/6.1/Linux/nomachine_6.1.6_9_x86_64.rpm
    #dnf install -y http://rpmfind.net/linux/mageia/distrib/cauldron/x86_64/media/core/release/dunst-1.3.1-1.mga7.x86_64.rpm
    dnf install $(curl -s https://api.github.com/repos/saenzramiro/rambox/releases/latest | jq -r ".assets[] | select(.name) | select(.browser_download_url | test(\"64.*rpm$\")) | .browser_download_url") -y
    dnf install $( curl -s https://api.github.com/repos/mbusb/multibootusb/releases/latest | jq -r ".assets[] | select(.name) | select(.browser_download_url | test(\".*rpm$\")) | .browser_download_url" | head -1 ) -y


    mkdir -p $HOME/.config/mpd
    touch $HOME/.config/mpd/database
    # Create swap file
    # create_swap_file 4 /swapfile
    # echo "/swapfile none swap sw 0 0" | tee -a /etc/fstab
}


function sys_config {
    localedef -i nl_BE -f UTF-8 nl_BE.UTF-8
    cat <<'EOL' | tee /etc/locale.conf
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

#     cat <<'EOL' | tee /etc/fonts/local.conf
# <?xml version='1.0'?>
# <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
# <fontconfig>
# <match target="font">
#     <edit name="antialias" mode="assign">
#         <bool>true</bool>
#     </edit>
#     <edit name="autohint" mode="assign">
#         <bool>false</bool>
#     </edit>
#     <edit name="hinting" mode="assign">
#         <bool>true</bool>
#     </edit>
#     <edit name="hintstyle" mode="assign">
#         <const>hintslight</const>
#     </edit>
#     <edit name="lcdfilter" mode="assign">
#         <const>lcddefault</const>
#     </edit>
#     <edit name="rgba" mode="assign">
#         <const>rgb</const>
#     </edit>
#     <edit name="embeddedbitmap" mode="assign">
#         <bool>false</bool>
#     </edit>
# </match>
# </fontconfig>
# EOL

    cat <<'EOL' | tee /etc/sysctl.conf
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
    cat <<'EOL' | tee /etc/resolv.conf
nameserver 1.1.1.1
nameserver 1.0.0.1
EOL


    cat <<'EOL' | tee /etc/vconsole.conf
KEYMAP="us"
FONT="ter-v16n"
EOL
}


function setup_custom_services {

cat << EOF | tee /etc/systemd/system/wakelock.service
# file /etc/systemd/system/wakelock.service

[Unit]
Description=Lock the screen on resume from suspend

[Service]
User=mandy
Type=forking
Environment=DISPLAY=:0
ExecStart=/home/mandy/.config/i3/scripts/lock

[Install]
WantedBy=sleep.target
WantedBy=suspend.target
EOF

systemctl enable wakelock

}

function setup_firewall {
    firewall-cmd --zone=public --permanent --add-service=http
    firewall-cmd --zone=public --permanent --add-service=https
    firewall-cmd --zone=public --permanent --add-service=mysql

    firewall-cmd --permanent --new-service=xdebug
    firewall-cmd --zone=public --permanent --add-service=xdebug

    firewall-cmd --permanent --service=xdebug --add-port=9000/tcp
    firewall-cmd --permanent --service=xdebug --add-port=9000/udp
    firewall-cmd --reload
}

function add_repositories {
    # Persist extra repos and import keys.
    cat << EOF | tee /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

    rpm --import https://dl-ssl.google.com/linux/linux_signing_key.pub

    rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-28.noarch.rpm
    rpm -ivh http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-28.noarch.rpm
    rpm -ivh https://rpms.remirepo.net/fedora/remi-release-28.rpm
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    dnf install -y http://mirror.yandex.ru/fedora/russianfedora/russianfedora/free/fedora/releases/28/Everything/x86_64/os/russianfedora-free-release-28-1.noarch.rpm
#    dnf install https://www.rpmfind.net/linux/sourceforge/u/un/unitedrpms/27/x86_64/msttcorefonts-2.5-4.fc27.noarch.rpm -y

    dnf copr enable dawid/better_fonts -y
    #dnf config-manager --set-enabled remi-php72
    dnf copr enable yaroslav/i3desktop -y
    rpm --import https://dl.tvcdn.de/download/linux/signature/TeamViewer2017.asc

    rpm --import https://build.opensuse.org/projects/home:manuelschneid3r/public_key
    dnf config-manager --add-repo https://download.opensuse.org/repositories/home:manuelschneid3r/Fedora_28/home:manuelschneid3r.repo

    # Sublime text
    rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
    dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

}

function system_update {
    package-cleanup -y --oldkernels --count=2
    dnf update -y --refresh
}



function all {
    base
    multimedia
    virtualization
    wine
    openbox
#    cinnamon
    networkutilities
    development
    system_update
}

function multimedia {
    # Audio
    dnf install -y ffmpeg flacon shntool cuetools
    dnf install -y mpc mpd mpv rhythmbox
    # Photo
    dnf install -y gimp darktable

    # Video
    dnf install -y vlc

    dnf install -y @multimedia
}

function virtualization {
    dnf install -y VirtualBox
}

function wine {
    dnf install -y wine playonlinux
}


function openbox {
    dnf install -y openbox openbox-theme-mistral-thin openbox-theme-mistral-thin-dark obconf obmenu
}

function gnome {
    dnf install -y gnome-desktop
}

function cinnamon {
    dnf install -y cinnamon-desktop
}

function networkutilities {
    dnf install -y nmap tcpdump ncdu

}

function development {
    dnf install -y docker-ce docker-compose
    systemctl enable docker

    dnf install -y meld filezilla ShellCheck
    
    pip3 install mycli
    pip3 install httpie
    
    # The fuck
    dnf install -y python3-devel
    pip3 install thefuck

    # Vagrant
    cd /tmp
    curl https://releases.hashicorp.com/vagrant/2.1.1/vagrant_2.1.1_linux_amd64.zip -o vagrant.zip
    unzip vagrant.zip
    rm -rf /usr/bin/vagrant
    mv vagrant /usr/bin/vagrant

        
    # Install Dry, 
    # dry is a terminal application to manage and monitor Docker containers.
    # See https://moncho.github.io/dry/
    if [ ! -f /usr/local/bin/dry ]; then
        curl -sSf https://moncho.github.io/dry/dryup.sh | sh
        chmod 755 /usr/local/bin/dry
        chmod +x /usr/local/bin/dry
    fi
    
    


    php_tools


    mkdir -p $HOME/go
}

function php_tools {
        # PHP
    dnf install -y composer php-pecl-imagick
    su mandy bash -c 'composer global require "acacha/llum"'
    su mandy bash -c 'composer global require "acacha/adminlte-laravel-installer"'
    su mandy bash -c 'composer global require "symfony/console"'
    su mandy bash -c 'composer global require "jolicode/jolinotif"'
    su mandy bash -c 'composer global require "squizlabs/php_codesniffer"'
    
    dnf install -y php-pear php-devel re2c
    pecl channel-update pecl.php.net
    pecl install "channel://pecl.php.net/ui-2.0.0"

}

function developer_tools {
    dnf install -y fedora-packager @development-tools rpmlint
    usermod -a -G mock $USER

    rpmdev-setuptree
    cd ~/rpmbuild/SOURCES
    wget http://ftp.gnu.org/gnu/hello/hello-2.10.tar.gz

}


function idea_configs() {
    su mandy bash -c "find ~ -maxdepth 1 -type d -name '.PhpStorm*' | xargs -I {} mkdir -p '{}/config/colors'"
    su mandy bash -c "find ~ -maxdepth 1 -type d -name '.PhpStorm*' | xargs -I {} cp $DIR/../../.config/.PhpStorm/config/colors/Xresources.icls '{}/config/colors'"

}

# Welcome message
echo_message welcome "$TITLE"

if [ "$1" != '' ]; then
    echo_message header "Starting '$1' function from cli parameter"
    $1
    exit 0
fi
# main
while :
do
	main
done