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

source ~/.functions

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
    cat <<'EOL' | sed '/^#/ d' | sed 's/#.*$//g' |  sed '/^$/d'  | tr '\n' ' ' | xargs -I {} sh -c 'dnf install -y {}'
@core
@standard
@hardware-support
@base-x
@firefox
@fonts
terminus-fonts-console
# fontconfig-enhanced-defaults
# fontconfig-font-replacements
@kde
plasma-sdk
ark
@multimedia
@printing
@development-tools
byzanz # record gif
vim

dnf-plugins-core
redhat-rpm-config
dnf-plugin-system-upgrade
rpmconf

htop
iotop

git
tig
gitflow

strace
system-config-printer

# i3
# i3lock
# wmctrl
# xterm
zsh
google-roboto-fonts
redshift

unzip
unrar

openssh
arandr

byobu
tmux

xsel
xclip
yad

ruby
ruby-devel

synergy

virt-what

jq
ImageMagick

gnupg
openssl-devel
gcc-c++
make
neofetch

glibc-locale-source

wget
vpnc

curl
sqlite

openssh-askpass

qdirstat

keepassxc

qt-config
qt5-qtstyleplugins
exa
java-1.8.0-openjdk


fuse
cifs-utils
gvfs-fuse
fuse-exfat
fuse-sshfs
exfat-utils

vlc

gnuplot

system-config-kickstart
mediawriter
xss-lock
libvirt
albert

openvpn
pykickstart

sublime-text
xbacklight
mesa-dri-drivers

okular
console-setup
xfce4-terminal
EOL
    status=$?
    if [ $status -ne 0 ]; then
        echo "Install exited with status ${status}"
        exit 2
    fi
    dnf remove gnome-calculator evince file-roller gedit gedit-plugins gnucash redshift-gtk lightdm -y

    su mandy bash -c "rm -rf ~/.gemrc; ln -sf ${DIR}/../../.gemrc ~/.gemrc"

    gem install json --no-ri --no-rdoc
    gem install teamocil --no-ri --no-rdoc

    # Fixes for pulseaudio
    sed -E -i 's#.*autospawn.*#autospawn = yes#g' /etc/pulse/client.conf
    pulseaudio -k || true

    # install xrectsel
    which xrectsel >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        dnf install autoconf automake -y
        bash ~/dotfiles/installers/install-xrectsel.sh
    fi


    usermod -a -G docker mandy || true
    groupadd power || true
    usermod -a -G power mandy || true
    usermod -a -G disk mandy || true
    chsh -s /bin/zsh mandy || true


    dnf install -y $DIR/rpms/jetbrains-toolbox*.rpm

    set +e
    which xbanish >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        bash $HOME/dotfiles/installers/xbanish.sh
    fi
    set -e

    dnf install https://s3.amazonaws.com/purevpn-dialer-assets/linux/app/purevpn-1.0.0-1.amd64.rpm

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
    set +x
}


function sys_config {
    localedef -i nl_BE -f UTF-8 nl_BE.UTF-8
    cat <<'EOL' > /etc/locale.conf
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

     cat <<'EOL' | tee /etc/fonts/local.conf
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

    cat <<'EOL' > /etc/sysctl.conf
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
# https://superuser.com/questions/351387/how-to-stop-kernel-messages-from-flooding-my-console default 4417
kernel.printk = 2 4 1 7
EOL

# @todo https://coderwall.com/p/66kbaw/adding-entries-to-resolv-conf-on-fedora
    cat <<'EOL' > /etc/resolv.conf
nameserver 1.1.1.1
nameserver 1.0.0.1
EOL


    cat <<'EOL' > /etc/vconsole.conf
KEYMAP="us"
FONT="ter-v32n"
EOL
}


function setup_custom_services {
    set -x
    cp $DIR/../..//services/tty-switching.service /etc/systemd/system/
    systemctl daemon-reload

    systemctl enable tty-switching
    systemctl start tty-switching
    set +x
}


function macbook {
    cp $DIR/../..//services/macbook-keyboard.service /etc/systemd/system/
    systemctl daemon-reload
    systemctl enable macbook-keyboard
    systemctl start macbook-keyboard

    cat <<'EOL' > /etc/default/console-setup
# CONFIGURATION FILE FOR SETUPCON

# Consult the console-setup(5) manual page.

ACTIVE_CONSOLES=guess

CHARMAP=guess

CODESET=guess
FONTFACE=TerminusBold
FONTSIZE=16x32

VIDEOMODE=

# The following is an example how to use a braille font
# FONT='lat9w-08.psf.gz brl-8x8.psf'
EOL

# Only for Macbook with HiDpi display
# Change font size to 16x32 in /etc/default/console-setup
# Fix alt arrow behaviour of switching ttys: sudo sh -c 'dumpkeys |grep -v cr_Console |loadkeys'
add-to-file "stty rows 50" "$HOME/.profile"


}


function setup_firewall {
    set -x
    firewall-cmd --zone=public --permanent --add-service=http
    firewall-cmd --zone=public --permanent --add-service=https
    firewall-cmd --zone=public --permanent --add-service=mysql

    firewall-cmd --permanent --new-service=xdebug
    firewall-cmd --zone=public --permanent --add-service=xdebug

    firewall-cmd --permanent --service=xdebug --add-port=9000/tcp
    firewall-cmd --permanent --service=xdebug --add-port=9000/udp

    # KDE Connect
    firewall-cmd --zone=public --permanent --add-port=1714-1764/tcp
    firewall-cmd --zone=public --permanent --add-port=1714-1764/udp

    firewall-cmd --reload
    set +x
}

function add_repositories {
    set -x
    # Persist extra repos and import keys.
#    cat << EOF > /etc/yum.repos.d/google-chrome.repo
#[google-chrome]
#name=google-chrome
#baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
#enabled=1
#gpgcheck=1
#gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
#EOF

    rpm --import https://dl-ssl.google.com/linux/linux_signing_key.pub

    rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-28.noarch.rpm
    rpm -ivh http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-28.noarch.rpm
    rpm -ivh https://rpms.remirepo.net/fedora/remi-release-28.rpm

    dnf install -y http://mirror.yandex.ru/fedora/russianfedora/russianfedora/free/fedora/releases/28/Everything/x86_64/os/russianfedora-free-release-28-1.noarch.rpm
#    dnf install https://www.rpmfind.net/linux/sourceforge/u/un/unitedrpms/27/x86_64/msttcorefonts-2.5-4.fc27.noarch.rpm -y

    dnf copr enable dawid/better_fonts -y
    dnf copr enable yaroslav/i3desktop -y
    rpm --import https://dl.tvcdn.de/download/linux/signature/TeamViewer2017.asc

    # For albert
    rpm --import https://build.opensuse.org/projects/home:manuelschneid3r/public_key
    dnf config-manager --add-repo https://download.opensuse.org/repositories/home:manuelschneid3r/Fedora_28/home:manuelschneid3r.repo

    # Sublime text
    rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
    dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

    set +x
}

function system_update {
    package-cleanup -y --oldkernels --count=5
    dnf update -y --refresh
}



function all {
    base
    multimedia
    virtualization
    wine
#    openbox
#    cinnamon
    networkutilities
    development
    system_update
}

function multimedia {
    # Audio
    dnf install -y ffmpeg flacon shntool cuetools
    dnf install -y mpc mpd mpv rhythmbox ncmpcpp
    dnf install -y $DIR/rpms/cli-visualizer*.rpm

    # Photo
    dnf install -y pinta darktable
    dnf remove -y gimp

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
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    dnf install -y docker-ce docker-compose
    systemctl enable docker

    dnf install -y meld filezilla ShellCheck
    
    pip3 install mycli
    pip3 install httpie
    
    # The fuck
    dnf install -y python3-devel
    pip3 install thefuck

    # Vagrant
    dnf install -y https://releases.hashicorp.com/vagrant/2.1.2/vagrant_2.1.2_x86_64.rpm

        
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
    dnf install -y composer php-pecl-imagick kcachegrind
    su mandy bash -c 'composer global require "acacha/llum"'
    su mandy bash -c 'composer global require "acacha/adminlte-laravel-installer"'
    su mandy bash -c 'composer global require "symfony/console"'
    su mandy bash -c 'composer global require "jolicode/jolinotif"'
    su mandy bash -c 'composer global require "squizlabs/php_codesniffer"'
    
    dnf install -y php-pear php-devel re2c
    pecl channel-update pecl.php.net
#    pecl install "channel://pecl.php.net/ui-2.0.0"

}

function developer_tools {
    dnf install -y fedora-packager @development-tools rpmlint
    usermod -a -G mock $USER

    rpmdev-setuptree
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