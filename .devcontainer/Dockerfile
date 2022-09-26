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
RUN curl -SLlk https://raw.githubusercontent.com/OhMyMndy/deb-get/install-exit-status-code/deb-get > /bin/deb-get \
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
unzip \
xz-utils \
&& \
apt-get autoclean && \
rm -rf \
/var/lib/apt/lists/* \
/var/tmp/* \
/tmp/*

RUN curl -fsSLk https://get.pnpm.io/install.sh | bash -

USER $USERNAME
RUN curl -sSLk https://webi.sh/webi | sh 
RUN source ~/.config/envman/PATH.env && webi node@lts
RUN source ~/.config/envman/PATH.env && webi deno
RUN source ~/.config/envman/PATH.env && webi go-essentials



RUN mkdir -p /home/$USERNAME/.vscode-server/extensions \
        /home/$USERNAME/.vscode-server-insiders/extensions \
    && chown -R $USERNAME \
        /home/$USERNAME/.vscode-server \
        /home/$USERNAME/.vscode-server-insiders
