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
gimp
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
pcmanfm
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
%end


#todo

# rofi
# xbanish
# peco


# Post-installation Script

%post

# This is the trick — automatically switch to 6th console
# and redirect all input/output
exec < /dev/tty6 > /dev/tty6 2> /dev/tty6
chvt 6

gem install json >> /tmp/post.log
git clone https://github.com/Mandy91/dotfiles.git /home/mandy/dotfiles >> /tmp/post.log
ruby /home/mandy/dotfiles/install.rb >> /tmp/post.log
bash /home/mandy/dotfiles/link.sh >> /tmp/post.log

# Persist extra repos and import keys.
cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

rpm --import https://dl-ssl.google.com/linux/linux_signing_key.pub >> /home/mandy/post.log

rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-27.noarch.rpm >> /home/mandy/post.log
rpm -ivh http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-27.noarch.rpm >> /home/mandy/post.log

dnf install $(curl -s https://api.github.com/repos/atom/atom/releases/latest | jq -r ".assets[] | select(.name) | select(.browser_download_url | test(\"rpm$\")) | .browser_download_url") -y >> /home/mandy/post.log
dnf install $(curl -s https://api.github.com/repos/saenzramiro/rambox/releases/latest | jq -r ".assets[] | select(.name) | select(.browser_download_url | test(\"64.*rpm$\")) | .browser_download_url") -y >> /home/mandy/post.log

systemctl enable lightdm >> /home/mandy/post.log
systemctl enable docker >> /home/mandy/post.log
usermod -a -G docker mandy >> /home/mandy/post.log
groupadd power >> /home/mandy/post.log
usermod -a -G power mandy >> /home/mandy/post.log
chsh -s /bin/zsh mandy >> /home/mandy/post.log

virt-what | grep -q -i virtualbox && dnf install VirtualBox-guest-additions -y >> /home/mandy/post.log

dnf update -y

# Then switch back to Anaconda on the first console
chvt 1
exec < /dev/tty1 > /dev/tty1 2> /dev/tty1

%end



# Reboot After Installation
reboot --eject
