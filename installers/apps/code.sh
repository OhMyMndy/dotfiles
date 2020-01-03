#!/usr/bin/env bash

trap "exit" INT
set -e

function install() {
    code --install-extension "$@" >/dev/null
}

#Vim
install fallenwood.viml

# Themes and keybindings
install k--kato.intellij-idea-keybindings
install pkief.material-icon-theme
install equinusocio.vsc-material-theme
install dracula-theme.theme-dracula
install robbowen.synthwave-vscode


# Languages
install naumovs.color-highlight
install redhat.vscode-yaml
install malmaud.tmux
install ms-python.python
install jetmartin.bats



# Markdown
install chintans98.markdown-jira
install davidanson.vscode-markdownlint

# Intellisense
install christian-kohler.path-intellisense
install visualstudioexptteam.vscodeintellicode
install esbenp.prettier-vscode


install bmewburn.vscode-intelephense-client

install xyz.local-history
install mrmlnc.vscode-duplicate



install mads-hartmann.bash-ide-vscode
install gruntfuggly.todo-tree

# Docker
install exiasr.hadolint
install ms-azuretools.vscode-docker

# CI
install jvandyke.vscode-circleci

# PHP
install mandy91.vscode-phpstan
install felixfbecker.php-pack



# Typescript
install ms-vscode.vscode-typescript-tslint-plugin


# Git
install atlassian.atlascode
install eamodio.gitlens
install donjayamanne.githistory