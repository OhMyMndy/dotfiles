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

if [[ ! -d ~/.config/nvim/.git ]]; then
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
fi

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Ohmyzsh
if [[ ! -d ~/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi



do_stow "$DIR/tmux"
do_stow "$DIR/vim"
rm -f ~/.zshrc
do_stow "$DIR/zsh"
do_stow "$DIR/polybar"
do_stow "$DIR/i3"
do_stow "$DIR/rofi"


do_stow "$DIR/nvim"
do_stow "$DIR/nixpkgs"

# it doesn't like relative paths...

if [[ -d "$DIR/xfce4-terminal" ]]; then
    do_stow_absolute "$DIR/xfce4-terminal"
fi



# @todo install lazygit

if command -v nvim &>/dev/null; then
    if [[ "$TERM" = '' ]]; then
        export TERM=xterm
    fi

    # Just try to PackerSync a couple of times because it it quite flakey...
    
    # shellcheck disable=SC2034
    # for VARIABLE in 1 2 3
    # do
     #   timeout 60 nvim -V1 --headless -c 'autocmd User PackerComplete quitall' -c 'silent PackerSync'
    # done
    
    #nvim -V1 --headless +MasonInstallAll +qa
else
    echo "Neovim is not installed, not configuring!" 1>&2
fi


