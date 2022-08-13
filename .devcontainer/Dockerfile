FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu
ENV USERNAME=vscode



RUN apt-get update && apt-get install -y -qq python3 python3-pip shellcheck vim wget curl neovim tmux tree yadm --no-install-recommends
# RUN apk add --no-cache nodejs npm
RUN wget -qO- "https://github.com/hadolint/hadolint/releases/download/v1.17.3/hadolint-Linux-x86_64" > hadolint \
    && cp "hadolint" /usr/bin/ \
    && chmod +x /usr/bin/hadolint


# hadolint ignore=DL3013
RUN pip3 install wheel
# hadolint ignore=DL3013
RUN pip3 install setuptools
# hadolint ignore=DL3013
RUN pip3 install yamllint
# hadolint ignore=DL3013
RUN pip3 install vim-vint
# hadolint ignore=DL3013
# RUN npm install -g markdownlint-cli

RUN passwd -d vscode
RUN chsh -s /bin/zsh vscode

USER $USERNAME


RUN mkdir -p /home/$USERNAME/.vscode-server/extensions \
        /home/$USERNAME/.vscode-server-insiders/extensions \
    && chown -R $USERNAME \
        /home/$USERNAME/.vscode-server \
        /home/$USERNAME/.vscode-server-insiders
