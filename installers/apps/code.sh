#!/usr/bin/env bash

trap "exit" INT

#Vim
code --install-extension fallenwood.viml

# Themes and keybindings
code --install-extension k--kato.intellij-idea-keybindings
code --install-extension pkief.material-icon-theme
code --install-extension equinusocio.vsc-material-theme
code --install-extension dracula-theme.theme-dracula

# Languages
code --install-extension naumovs.color-highlight
code --install-extension redhat.vscode-yaml
code --install-extension malmaud.tmux
code --install-extension ms-python.python

# 




# Markdown
code --install-extension chintans98.markdown-jira
code --install-extension davidanson.vscode-markdownlint

# Intellisense
code --install-extension christian-kohler.path-intellisense
code --install-extension visualstudioexptteam.vscodeintellicode
code --install-extension esbenp.prettier-vscode


code --install-extension bmewburn.vscode-intelephense-client

code --install-extension xyz.local-history



code --install-extension mads-hartmann.bash-ide-vscode
code --install-extension gruntfuggly.todo-tree

# Docker
code --install-extension exiasr.hadolint
code --install-extension ms-azuretools.vscode-docker

# CI
code --install-extension jvandyke.vscode-circleci

# PHP
code --install-extension mandy91.vscode-phpstan


# Typescript
code --install-extension ms-vscode.vscode-typescript-tslint-plugin


# Git
code --install-extension atlassian.atlascode
code --install-extension eamodio.gitlens
code --install-extension donjayamanne.githistory