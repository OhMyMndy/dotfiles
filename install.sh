#!/usr/bin/env bash

clear

# set -e

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

function do_stow_absolute() {
    xstow -force -absolute-path -restow -target="$HOME" "$1"
    echo
}

function do_stow() {
    xstow -force -restow -target="$HOME" "$1"
    echo
}

if [[ ! -d ~/.config/nvim ]]; then
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
fi

# Ohmyzsh
if [[ ! -d ~/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi



do_stow "$DIR/tmux"
do_stow "$DIR/vim"
rm -f ~/.zshrc
do_stow "$DIR/zsh"


do_stow "$DIR/nvim"

# it doesn't like relative paths...

if [[ -d "$DIR/xfce4-terminal" ]]; then
    do_stow_absolute "$DIR/xfce4-terminal"
fi



# @todo install lazygit

# Dependencies for nvim
# @todo install lts node and npm,npx
# $ sudo apt-get install golang gcc g++

if command -v nvim &>/dev/null; then
    if [[ "$TERM" = '' ]]; then
        export TERM=xterm
    fi

    # Just try to PackerSync a couple of times because it it quite flakey...
    
    # shellcheck disable=SC2034
    for VARIABLE in 1 2 3
    do
        timeout 60 nvim -V1 --headless -c 'autocmd User PackerComplete quitall' -c 'silent PackerSync'
    done
    
    nvim -V1 --headless +MasonInstallAll +qa
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
