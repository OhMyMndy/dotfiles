FROM mcr.microsoft.com/vscode/devcontainers/base:alpine-3.12
ENV USERNAME=vscode



RUN apk add --no-cache git python3 py3-pip shellcheck vim wget curl shadow
RUN apk add --no-cache nodejs npm
RUN wget -qO- "https://github.com/hadolint/hadolint/releases/download/v1.17.3/hadolint-Linux-x86_64" > hadolint \
    && cp "hadolint" /usr/bin/ \
    && chmod +x /usr/bin/hadolint



# hadolint ignore=DL3016
RUN npm install -g bats
# hadolint ignore=DL3013
RUN pip3 install wheel
# hadolint ignore=DL3013
RUN pip3 install setuptools
# hadolint ignore=DL3013
RUN pip3 install yamllint
# hadolint ignore=DL3013
RUN pip3 install vim-vint
# hadolint ignore=DL3013
RUN npm install -g markdownlint-cli

RUN apk add --no-cache build-base libffi-dev openssl-dev python3-dev

RUN pip3 install ansible
RUN pip3 install paramiko

RUN apk add --no-cache docker-cli
# RUN chown -R root:root /etc/sudo.conf /usr/lib/sudo/sudoers.so /etc/sudoers /etc/sudoers.d \
    # && chown -R root:root /usr/bin/sudo && chmod -R a=rx,u+ws /usr/bin/sudo


USER $USERNAME

RUN pip install -U pylint --user

RUN mkdir -p /home/$USERNAME/.vscode-server/extensions \
        /home/$USERNAME/.vscode-server-insiders/extensions \
    && chown -R $USERNAME \
        /home/$USERNAME/.vscode-server \
        /home/$USERNAME/.vscode-server-insiders
