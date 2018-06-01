# https://docs.fedoraproject.org/f26/install-guide/appendixes/Kickstart_Syntax_Reference.html

# Configure installation method
install

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
authselect --passalgo=sha512

# Create User Account
user --name=mandy --password=123 --plaintext --groups=wheel

# Set Root Password
rootpw --lock

# Perform Installation in Text Mode
text
# cmdline

# Package Selection
%packages
%end

# Post-installation Script

%post

export HOME=/home/mandy &>> /home/mandy/post.log
gem install json &>> /home/mandy/post.log
git clone https://github.com/Mandy91/dotfiles.git /home/mandy/dotfiles &>> /home/mandy/post.log

bash /home/mandy/dotfiles/installers/fedora27/install.sh base &>> /home/mandy/post.log
bash /home/mandy/dotfiles/installers/setup-nomachine.sh &>> /home/mandy/post.log

ruby /home/mandy/dotfiles/install.rb &>> /home/mandy/post.log

bash /home/mandy/dotfiles/link.sh &>> /home/mandy/post.log



chown -R mandy:mandy /home/mandy &>> /home/mandy/post.log
dnf update -y --refresh &>> /home/mandy/post.log
%end
