FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04 as base
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

RUN apt-get update && apt-get upgrade -y && \
    apt-get autoclean && \
    rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

RUN passwd -d vscode \
    && chsh -s /bin/zsh vscode

USER vscode
ENV USER=vscode


# default packages
RUN sudo apt-get update && \
DEBIAN_FRONTEND=noninteractive \
sudo apt-get install --no-install-recommends -y \
htop \
zsh \
tmux \
git \
tig \
tree \
file && \
sudo apt-get autoclean && \
sudo rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*

# PHP
RUN sudo apt-get update && \
DEBIAN_FRONTEND=noninteractive \
sudo apt-get install --no-install-recommends -y \
php-cli \
composer && \
sudo apt-get autoclean && \
sudo rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*

# fuse and bindfs
RUN sudo apt-get update && \
DEBIAN_FRONTEND=noninteractive \
sudo apt-get install --no-install-recommends -y \
fuse \
bindfs && \
sudo apt-get autoclean && \
sudo rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*

# xstow
RUN sudo apt-get update && \
DEBIAN_FRONTEND=noninteractive \
sudo apt-get install --no-install-recommends -y \
xstow && \
sudo apt-get autoclean && \
sudo rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*

# deb-get dependencies
RUN sudo apt-get update && \
DEBIAN_FRONTEND=noninteractive \
sudo apt-get install --no-install-recommends -y \
curl \
wget \
ca-certificates \
sudo \
jq \
lsb-release \
gpg-agent \
software-properties-common && \
sudo apt-get autoclean && \
sudo rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*

# neovim dependencies
# cargo, go, node, npm, python3, pip, venv
RUN curl -sL https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get | sudo -E bash -s install deb-get
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
RUN sudo apt-get update && \
DEBIAN_FRONTEND=noninteractive \
sudo apt-get install --no-install-recommends -y \
cargo \
nodejs \
python3-pip \
python3-venv \
ripgrep && \
sudo apt-get autoclean && \
sudo rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*

RUN deb-get install fd

RUN deb-get install terraform
RUN deb-get install google-cloud-cli
RUN deb-get install neovim
RUN deb-get install yq
# @todo add kubectl and other k8s tools

# Install deb-get from source instead of the .deb
RUN curl -sL https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get | sudo -E bash -s install deb-get
 
RUN curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh

# distrobox dependencies @see https://github.com/89luca89/distrobox/blob/main/distrobox-init#L301
# RUN sudo apt-get update && \
# DEBIAN_FRONTEND=noninteractive \
# sudo apt-get install -y --no-install-recommends \
# apt-utils \
# bc \
# curl \
# dialog \
# diffutils \
# findutils \
# gnupg2 \
# less \
# libnss-myhostname \
# libvte-2.9[0-9]-common \
# libvte-common \
# lsof \
# ncurses-base \
# passwd \
# pinentry-curses \
# procps \
# sudo \
# time \
# wget \
# util-linux \
# libegl1-mesa \
# libgl1-mesa-glx && \
# sudo apt-get autoclean && \
# sudo rm -rf \
# /var/lib/apt/lists/* \
# /var/tmp/* \
# /tmp/*

# Run apt-get -y -f to fix: E: Unable to correct problems, you have held broken packages.
# RUN sudo deb-get install docker-ce; \
#     sudo apt-get install -y -f; \
#     sudo deb-get install docker-ce

ENV PATH="/home/vscode/.nix-profile/bin:/home/vscode/.local/bin:/home/vscode.krew/bin:/home/vscode/.tfenv/bin:$PATH" 

RUN mkdir -p /home/vscode/.vscode-server/extensions \
        /home/vscode/.vscode-server-insiders/extensions \
    && chown -R vscode \
        /home/vscode/.vscode-server \
        /home/vscode/.vscode-server-insiders

COPY --chown=vscode:vscode ./ /home/vscode/dotfiles


RUN /home/vscode/dotfiles/install.sh



# FROM base as with-nix

# RUN sh <(curl -L https://nixos.org/nix/install) --no-daemon \
#   && . "/home/vscode/.nix-profile/etc/profile.d/nix.sh" \
#   && nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixos-unstable \
#   && nix-channel --update

