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
curl
git
%end

# Post-installation Script

%post

export HOME=/home/mandy &>> /home/mandy/post.log
gem install json &>> /home/mandy/post.log
git clone https://github.com/Mandy91/dotfiles.git /home/mandy/dotfiles &>> /home/mandy/post.log

bash /home/mandy/dotfiles/installers/fedora27/install.sh base &>> /home/mandy/post.log

ruby /home/mandy/dotfiles/install.rb &>> /home/mandy/post.log

bash /home/mandy/dotfiles/link.sh &>> /home/mandy/post.log


chown -R mandy:mandy /home/mandy &>> /home/mandy/post.log
%end
