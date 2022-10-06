FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04
ENV USERNAME=vscode
SHELL ["/bin/bash", "-o", "pipefail", "-c"]


RUN wget -qO- "https://github.com/hadolint/hadolint/releases/download/v2.10.0/hadolint-Linux-x86_64" > hadolint \
    && cp "hadolint" /usr/bin/ \
    && chmod +x /usr/bin/hadolint


RUN passwd -d vscode
RUN chsh -s /bin/zsh vscode

RUN \
apt-get update && \
DEBIAN_FRONTEND=noninteractive \
apt-get install --no-install-recommends -y \
git \
tig \
shellcheck \yamllint \
less \
moreutils \
python3.10-venv \
python3-pip \
htop \
tmux \
xstow \
zsh \
fzf \
rsync \
curl \
sudo \
jq \
nmap \
ncdu \
openssh-server \
lsb-release && \
apt-get autoclean && \
rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*


# fuse and bindfs
RUN \
apt-get update && \
DEBIAN_FRONTEND=noninteractive \
apt-get install --no-install-recommends -y \
fuse \
bindfs && \
apt-get autoclean && \
rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*

# i3 with novnc
RUN \
apt-get update && \
DEBIAN_FRONTEND=noninteractive \
apt-get install --no-install-recommends -y \
i3 rofi novnc xvfb x11vnc supervisor && \
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
gpg-agent \
software-properties-common && \
apt-get autoclean && \
rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*

# Install deb-get from source instead of the .deb
RUN curl -SLl https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get > /bin/deb-get \
&& chmod +x /bin/deb-get

RUN deb-get install neovim \
&& deb-get install terraform \
&& deb-get install yq \
&& deb-get install google-cloud-cli

RUN deb-get install docker-ce \
&& apt-get update && \
DEBIAN_FRONTEND=noninteractive \
apt-get install --no-install-recommends -y \
fuse-overlayfs \
&& \
apt-get autoclean && \
rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*
# neovim dependencies
RUN \
apt-get update && \
DEBIAN_FRONTEND=noninteractive \
apt-get install --no-install-recommends -y \
gcc \
g++ \
ripgrep \
unzip \
xz-utils \
golang-go \
python3-pip \
&& \
apt-get autoclean && \
rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*

RUN curl -fsSL https://get.pnpm.io/install.sh | bash -
RUN curl -fsSL https://deno.land/x/install/install.sh | sh

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
apt-get update && \
DEBIAN_FRONTEND=noninteractive \
apt-get install --no-install-recommends -y \
nodejs \
&& \
apt-get autoclean && \
rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*

USER $USERNAME


RUN mkdir -p /home/$USERNAME/.vscode-server/extensions \
        /home/$USERNAME/.vscode-server-insiders/extensions \
    && chown -R $USERNAME \
        /home/$USERNAME/.vscode-server \
        /home/$USERNAME/.vscode-server-insiders

COPY --chown=vscode:vscode ./ /home/vscode/dotfiles
RUN /home/vscode/dotfiles/install.sh