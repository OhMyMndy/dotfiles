#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR" || exit 1
# shellcheck source=../../.base-script.sh
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../../.base-script.sh" 2>/dev/null

function install() {
    if command -v code &>/dev/null; then
        code --install-extension "$@" >/dev/null
    fi
    if command -v code-server &>/dev/null; then
        code-server --install-extension "$@" >/dev/null
    fi
}

function write_setting() {
    settings_file="$HOME/.config/Code/User/settings.json"
    if [[ ! -f $settings_file ]]; then
        mkdir -p "$(dirname "$settings_file")"
        echo "{}" > "$settings_file"
    fi
    
    if  command -v json &>/dev/null; then
        json -f "$settings_file" -I -e "$@"
    fi
}

function settings() {
    write_setting "this['git.autofetch'] = true"
    write_setting "this['workbench.iconTheme'] = 'material-icon-theme'"
    write_setting "this['terminal.integrated.minimumContrastRatio'] = 9"
    write_setting "this['terminal.integrated.drawBoldTextInBrightColors'] = false"
    write_setting "this['files.exclude'] = { \"**/.*.un~\": true, \"**/.history/**\": true }"
    write_setting "this['files.watcherExclude'] = { \"**/.*.un~\": true, \"**/.history/**\": true }"
    write_setting "this['shellcheck.customArgs'] = [ '-x' ]"
    write_setting "this['bashIde.path'] = '$HOME/.local/bin/bash-language-server'"
    write_setting "this['shellcheck.executablePath'] = '/usr/bin/shellcheck'"
}


# @see https://itnext.io/why-i-wrote-33-vscode-extensions-and-how-i-manage-them-cb61df05e154

# Project management
install fabiospampinato.vscode-projects-plus
install fabiospampinato.vscode-terminals

#Vim
install fallenwood.viml

# Themes and keybindings
install k--kato.intellij-idea-keybindings
install pkief.material-icon-theme
install equinusocio.vsc-material-theme
install dracula-theme.theme-dracula
install robbowen.synthwave-vscode
install lkytal.flatui
install mbetacchini.massimo-theme



# Languages
install naumovs.color-highlight
install redhat.vscode-yaml
install malmaud.tmux
install ms-python.python
install jetmartin.bats

install streetsidesoftware.code-spell-checker
install mcright.auto-save


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

install sourcegraph.sourcegraph


install mads-hartmann.bash-ide-vscode
install gruntfuggly.todo-tree

# Docker
install exiasr.hadolint
install ms-azuretools.vscode-docker
install ms-vscode-remote.remote-containers
install ms-vscode-remote.remote-ssh

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


install jomeinaster.bracket-peek


settings