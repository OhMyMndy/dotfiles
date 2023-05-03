FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04 as base
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# RUN apt-get update && apt-get upgrade -y && \
#     apt-get autoclean && \
#     rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

RUN passwd -d vscode && chsh -s /bin/zsh vscode

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends -y \
    curl \
    uidmap \
    acl && \
    apt-get autoclean && \
    rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

RUN mkdir -m 0755 /nix && chown vscode:vscode /nix
RUN mkdir --parents /etc/nix/ && \
    echo "sandbox = false" >> /etc/nix/nix.conf && \
    echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf && \
    echo "narinfo-cache-negative-ttl = 30" >> /etc/nix/nix.conf  && \
    echo "trusted-users = root vscode" >> /etc/nix/nix.conf  && \
    echo "substitute = true" >> /etc/nix/nix.conf  && \
    echo "substituters = https://cache.nixos.org/ https://composable-community.cachix.org/ https://devenv.cachix.org/ https://nix-community.cachix.org/" >> /etc/nix/nix.conf  && \
    echo "require-sigs = false" >> /etc/nix/nix.conf  && \
    echo "trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= composable-community.cachix.org-1:GG4xJNpXJ+J97I8EyJ4qI5tRTAJ4i7h+NK2Z32I8sK8= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= nixpkgs-update.cachix.org-1:6y6Z2JdoL3APdu6/+Iy8eZX2ajf09e4EE9SnxSML1W8=" >> /etc/nix/nix.conf  && \
    echo "trusted-substituters = https://cache.nixos.org/ https://composable-community.cachix.org/ https://devenv.cachix.org/ https://nix-community.cachix.org/" >> /etc/nix/nix.conf

# Podman uid/gid
RUN echo "vscode:100000:64535" > /etc/subuid /etc/subgid

USER vscode
ENV USER=vscode

RUN sh <(curl -L https://nixos.org/nix/install) --no-daemon
RUN mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf


RUN echo "source ~/.nix-profile/etc/profile.d/nix.sh" >> ~/.bashrc && \
    echo "source ~/.nix-profile/etc/profile.d/nix.sh" >> ~/.profile && \
    echo "source ~/.nix-profile/etc/profile.d/nix.sh" >> ~/.bash_profile && \
    echo "source ~/.nix-profile/etc/profile.d/nix.sh" >> ~/.zshrc

RUN mkdir -p /home/vscode/.vscode-server/extensions /home/vscode/.vscode-server-insiders/extensions \
    && chown -R vscode /home/vscode/.vscode-server /home/vscode/.vscode-server-insiders

COPY --chown=vscode:vscode ./ /home/vscode/dotfiles

# see: https://github.com/ComposableFi/composable/blob/15eb5029ca32fb3ded71f47d2544285c9695a6b0/Dockerfile
RUN source ~/.nix-profile/etc/profile.d/nix.sh \
    && rm ~/.zshrc \
    && nix run . switch -- --flake .
# RUN /home/vscode/dotfiles/install.sh

