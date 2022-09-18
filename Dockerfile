FROM ghcr.io/linuxserver/baseimage-ubuntu:focal

# use Bash so we can use pipefail, often piping the output to curl to bash fails silently
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
apt-get update && \
DEBIAN_FRONTEND=noninteractive \
apt-get install --no-install-recommends -y \
git \
tig \
tmux \
xstow \
zsh \
tree \
curl \
sudo \
qemu-user-static \
lxcfs \
uidmap \
jq \
nmap \
lsb-release && \
apt-get autoclean && \
rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*

# deb-get dependencies
RUN \
apt-get update && \
DEBIAN_FRONTEND=noninteractive \
apt-get install --no-install-recommends -y \
curl \
wget \
ca-certificates \
sudo \
jq \
lsb-release \
software-properties-common && \
apt-get autoclean && \
rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*

# Install deb-get from source instead of the .deb
RUN curl -Sl https://raw.githubusercontent.com/OhMyMndy/deb-get/install-exit-status-code/deb-get > /bin/deb-get \
&& chmod +x /bin/deb-get

RUN deb-get install neovim \
&& deb-get install terraform \
&& deb-get install yq

# neovim dependencies
RUN \
apt-get update && \
DEBIAN_FRONTEND=noninteractive \
apt-get install --no-install-recommends -y \
gcc \
g++ \
ripgrep \
&& \
apt-get autoclean && \
rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*

RUN passwd -d abc

USER abc
COPY . /config/dotfiles
RUN /config/dotfiles/install.sh

USER root