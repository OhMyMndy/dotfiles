FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-24.04 as base

USER root

RUN passwd -d vscode && chsh -s /bin/zsh vscode

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends -y \
    curl \
    uidmap \
    acl \
    podman \
    slirp4netns \
    fuse-overlayfs \
    podman-docker \
    podman-toolbox \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN touch /etc/containers/nodocker

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
RUN echo "vscode:100000:65536" | tee /etc/subuid /etc/subgid >/dev/null

USER vscode
ENV USER=vscode

RUN curl -SsL https://nixos.org/nix/install -o /tmp/install.sh && sh /tmp/install.sh --no-daemon && rm -f /tmp/install.sh
RUN mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf


RUN echo ". ~/.nix-profile/etc/profile.d/nix.sh" | tee -a ~/.bashrc ~/.profile ~/.profile ~/.zshrc >/dev/null


RUN mkdir -p ~/.vscode-server/extensions ~/.vscode-server-insiders/extensions \
    && chown -R vscode ~/.vscode-server ~/.vscode-server-insiders

FROM base as home-manager

RUN mkdir -p ~/dotfiles
COPY --chown=vscode:vscode . /home/vscode/dotfiles

RUN ls -lash ~/dotfiles
RUN bash -c ". ~/.nix-profile/etc/profile.d/nix.sh && cd ~/dotfiles && nix run .#just"

# TODO run mason install
RUN bash -c ". ~/.nix-profile/etc/profile.d/nix.sh && nvim --headless +q && nvim --headless +AstroMasonUpdateAll"


FROM base as devcontainer
