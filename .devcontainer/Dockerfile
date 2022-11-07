FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

RUN passwd -d vscode \
    && chsh -s /bin/zsh vscode

USER vscode
ENV USER=vscode


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
/tmp/*i

# xstow
RUN sudo apt-get update && \
DEBIAN_FRONTEND=noninteractive \
sudo apt-get install --no-install-recommends -y \
xstow && \
sudo apt-get autoclean && \
sudo rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*i



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

# Install deb-get from source instead of the .deb
RUN curl -sL https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get | sudo -E bash -s install deb-get

RUN curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh

# distrobox dependencies @see https://github.com/89luca89/distrobox/blob/main/distrobox-init#L301
RUN sudo apt-get update && \
DEBIAN_FRONTEND=noninteractive \
sudo apt-get install -y \
apt-utils \
bc \
curl \
dialog \
diffutils \
findutils \
gnupg2 \
less \
libnss-myhostname \
libvte-2.9[0-9]-common \
libvte-common \
lsof \
ncurses-base \
passwd \
pinentry-curses \
procps \
sudo \
time \
wget \
util-linux \
libegl1-mesa \
libgl1-mesa-glx && \
sudo apt-get autoclean && \
sudo rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*


			
RUN sudo deb-get install docker-ce

RUN sh <(curl -L https://nixos.org/nix/install) --no-daemon \
    && . "/home/vscode/.nix-profile/etc/profile.d/nix.sh" \
    && nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixos-unstable \
    && nix-channel --update

ENV PATH "$PATH:/home/vscode/.nix-profile/bin"

RUN mkdir -p /home/vscode/.vscode-server/extensions \
        /home/vscode/.vscode-server-insiders/extensions \
    && chown -R vscode \
        /home/vscode/.vscode-server \
        /home/vscode/.vscode-server-insiders

COPY --chown=vscode:vscode ./ /home/vscode/dotfiles


RUN /home/vscode/dotfiles/install.sh