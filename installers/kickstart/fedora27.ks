# https://docs.fedoraproject.org/f26/install-guide/appendixes/Kickstart_Syntax_Reference.html

# Configure installation method
install

url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-27&arch=x86_64"

repo --name=fedora-updates --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f27&arch=x86_64" --cost=100

repo --name=rpmfusion-free --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-27&arch=x86_64" --includepkgs=rpmfusion-free-release

repo --name=rpmfusion-free-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-27&arch=x86_64" --includepkgs=rpmfusion-free-release


repo --name=google-chrome --baseurl="http://dl.google.com/linux/chrome/rpm/stable/x86_64"

repo --name=docker-ce --baseurl="https://download.docker.com/linux/fedora/27/x86_64/stable/"

# zerombr
# zerombr

# Configure Boot Loader
# bootloader --location=mbr --driveorder=sda


# Configure Firewall
firewall --enabled --ssh

# Configure Network Interfaces
network --onboot=yes --bootproto=dhcp

# Configure Keyboard Layouts
keyboard us

# Configure Language During Installation
lang en_US

# Configure X Window System
xconfig --startxonboot

# Configure Time Zone
timezone Europe/Brussels

# Configure Authentication
auth --passalgo=sha512

# Create User Account
user --name=mandy --password=123 --plaintext --groups=wheel

# Set Root Password
rootpw --lock

# Perform Installation in Text Mode
text
# cmdline

# Package Selection
%packages
-bluez
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
gnucash
htop
nmap
tcpdump
vlc
google-chrome-stable
calc
gitflow
redhat-rpm-config
rpmconf
strace
ffmpeg
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
dunst
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
evince
git
tig
ruby
ruby-devel
ncdu
meld
synergy
python3-udiskie
pulseaudio
mpc
mpd
gnome-disk-utility
docker-ce
docker-compose
gedit
gedit-plugins
geany
lightdm
xfce4-panel
xfce4-power-manager
virt-what
clementine
ffmpeg
flacon
shntool
cuetools
jq
ImageMagick
composer
cifs-utils
numix-gtk-theme
pop-icon-theme
dmz-cursor-themes
unclutter
flameshot
VirtualBox
fuse
shotwell
gnupg
openssl-devel
gcc-c++
make
neofetch
rhythmbox
xfce4-terminal
openbox
openbox-theme-mistral-thin
openbox-theme-mistral-thin-dark
obconf
flatpak
pasystray
glibc-locale-source
freetype-freeworld
wget
%end

# Post-installation Script

%post

set -x

localedef -i nl_BE -f UTF-8 nl_BE.UTF-8  &>> /home/mandy/post.log
cat <<'EOL' | sudo tee /etc/locale.conf &>> /home/mandy/post.log
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

cat <<'EOL' | sudo tee /etc/fonts/local.conf &>> /home/mandy/post.log
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

export HOME=/home/mandy &>> /home/mandy/post.log
gem install json &>> /home/mandy/post.log
git clone https://github.com/Mandy91/dotfiles.git /home/mandy/dotfiles &>> /home/mandy/post.log
ruby /home/mandy/dotfiles/install.rb &>> /home/mandy/post.log
bash /home/mandy/dotfiles/link.sh &>> /home/mandy/post.log
#bash /home/mandy/dotfiles/installers/fedora.sh &>> /home/mandy/post.log


# Persist extra repos and import keys.
cat << EOF > /etc/yum.repos.d/google-chrome.repo &>> /home/mandy/post.log
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

rpm --import https://dl-ssl.google.com/linux/linux_signing_key.pub &>> /home/mandy/post.log

rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-27.noarch.rpm &>> /home/mandy/post.log
rpm -ivh http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-27.noarch.rpm &>> /home/mandy/post.log

dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo  &>> /home/mandy/post.log

dnf install $(curl -s https://api.github.com/repos/saenzramiro/rambox/releases/latest | jq -r ".assets[] | select(.name) | select(.browser_download_url | test(\"64.*rpm$\")) | .browser_download_url") -y &>> /home/mandy/post.log

bash /home/mandy/dotfiles/installers/flatpak.sh | tee -a /home/mandy/post.log
bash /home/mandy/dotfiles/installers/jetbrains-toolbox.sh | tee -a /home/mandy/post.log

systemctl enable lightdm &>> /home/mandy/post.log
systemctl enable docker &>> /home/mandy/post.log
usermod -a -G docker mandy &>> /home/mandy/post.log
groupadd power &>> /home/mandy/post.log
usermod -a -G power mandy &>> /home/mandy/post.log
chsh -s /bin/zsh mandy &>> /home/mandy/post.log


dnf copr enable yaroslav/i3desktop -y &>> /home/mandy/post.log
dnf install rofi -y &>> /home/mandy/post.log

# install polybar
dnf install -y cmake @development-tools gcc-c++ i3-ipc jsoncpp-devel pulseaudio-libs-devel alsa-lib-devel wireless-tools-devel libmpdclient-devel libcurl-devel cairo-devel xcb-proto xcb-util-devel xcb-util-wm-devel xcb-util-image-devel &>> /home/mandy/post.log
dnf install -y pulseaudio-libs-devel xcb-util-xrm-devel &>> /home/mandy/post.log

rm -rf /tmp/polybar &>> /home/mandy/post.log
git clone --recursive https://github.com/jaagr/polybar /tmp/polybar &>> /home/mandy/post.log
cd /tmp/polybar &>> /home/mandy/post.log
mkdir build &>> /home/mandy/post.log
cd build &>> /home/mandy/post.log
cmake .. &>> /home/mandy/post.log
sudo make install &>> /home/mandy/post.log
# end install Polybar


virt-what | grep -q -i virtualbox && dnf install VirtualBox-guest-additions -y &>> /home/mandy/post.log

rpm --import https://dl.tvcdn.de/download/linux/signature/TeamViewer2017.asc &>> /home/mandy/post.log
dnf install https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm -y &>> /home/mandy/post.log

dnf install http://download.nomachine.com/download/6.0/Linux/nomachine_6.0.78_1_x86_64.rpm -y &>> /home/mandy/post.log

dnf copr enable sergiomb/google-drive-ocamlfuse -y &>> /home/mandy/post.log
dnf install google-drive-ocamlfuse -y &>> /home/mandy/post.log


# enable when everything is stable
dnf update -y &>> /home/mandy/post.log

chown -R mandy:mandy /home/mandy &>> /home/mandy/post.log

echo "Done"

%end
