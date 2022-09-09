#!/usr/bin/env bash

clear

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

if ! command -v xstow &>/dev/null; then
    echo "xstow has to be installed!" 1>&2
    exit 1
fi


if ! command -v curl &>/dev/null; then
    echo "curl has to be installed!" 1>&2
    exit 1
fi

if ! command -v curl &>/dev/null; then
    echo "curl has to be installed!" 1>&2
    exit 1
fi

function do_stow_absolute() {
    xstow --force -absolute-path -restow --target="$HOME" "$1"
    echo
}

function do_stow() {
    xstow --force -restow --target="$HOME" "$1"
    echo
}

if [[ ! -d ~/.config/nvim ]]; then
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
fi




do_stow "$HOME/dotfiles/tmux"
do_stow "$HOME/dotfiles/vim"
do_stow "$HOME/dotfiles/zsh"


do_stow "$HOME/dotfiles/nvim"

# it doesn't like relative paths...
do_stow_absolute "$HOME/dotfiles/xfce4-terminal"



# @todo install lazygit

# Dependencies for nvim
# @todo install lts node and npm,npx
# $ sudo apt-get install golang gcc g++

if command -v nvim &>/dev/null; then
    nvim --headless -c 'PackerSync'
    nvim --headless -c 'MasonInstallAll'
    # nvim --headless +
else
    echo "Neovim is not installed, not configuring!" 1>&2
fi


# fonts
if command -v fc-cache &>/dev/null; then
    if ! (fc-match ":family=JetBrainsMonoNL Nerd Font" | grep -q "JetBrainsMonoNL Nerd Font"); then
        echo "Installing Jetbrains Mono Nerd Font"
        mkdir -p "$HOME/.local/share/fonts/"
        jetBrainsMonoFile="$HOME/.local/share/fonts/JetBrains Mono NL Regular Nerd Font Complete.ttf"
        jetBrainsMono="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/JetBrainsMono/NoLigatures/Regular/complete/JetBrains%20Mono%20NL%20Regular%20Nerd%20Font%20Complete.ttf"
        curl -LsS "$jetBrainsMono" -o "$jetBrainsMonoFile"
        fc-cache "$HOME/.local/share/fonts/" --force --verbose
    fi
fi
