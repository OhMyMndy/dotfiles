#!/usr/bin/env bash

set -eu
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR" || exit 1
# shellcheck source=../.base-script.sh
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../.base-script.sh"

mkdir -p ~/.local/share/xfpanel-switch
mkdir -p ~/.config/{copyq,ulauncher,Thunar}
mkdir -p ~/Screenshots


function vim() {
    {
        set +e
        link-file "$ROOT_DIR" ".vimrc"
        link-file "$ROOT_DIR" ".config/nvim"
        mkdir -p ~/.vim/{sessions,undo-dir,bundle,view,autoload}

        ln -sf "${ROOT_DIR}"/.vim/autoload/* ~/.vim/autoload/
        # remove broken links
        find ~/.vim/autoload/ -xtype l -delete

        link-file "$ROOT_DIR" ".vim/coc-settings.json"

        find ~/.vim/bundle -maxdepth 1 -type d ! -path . -print0 | xargs -0 -r -i bash -c "cd {}/.git 2>/dev/null && cd .. && git pull -q"
        # command vim -c 'CocInstall -sync coc-highlight coc-json coc-html coc-phpls coc-python coc-markdownlint |q'
    }
}


function tmux() {
    {
        set +e
        link-file "$ROOT_DIR" '.byobu'

        mkdir -p ~/.tmux
        ln -sf ~/.byobu/.tmux.conf ~/.tmux.conf

        mkdir -p ~/.tmux/plugins
        if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
            git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        fi
        
        # shellcheck disable=SC1091
        # shellcheck source=/dev/null
        "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null
        command tmux source ~/.tmux.conf &>/dev/null
    }
}


function xfce() {
    mkdir -p ~/.config/Thunar
    link-file "$ROOT_DIR" ".config/Thunar/uca.xml"

    mkdir -p ~/.config/xfce4/
    link-file "$ROOT_DIR" ".config/xfce4/terminal"
}

function icons() {
    mkdir -p ~/.local/share/applications/icons

    link-file "$ROOT_DIR" '.local/share/applications/icons'
    ln -sf "${ROOT_DIR}"/.local/share/applications/*.desktop ~/.local/share/applications/
    # remove broken links
    find ~/.local/share/applications/ -xtype l -delete
    mkdir -p ~/.local/share/icons/hicolor/48x48/apps/
    ln -sf "${ROOT_DIR}"/.local/share/applications/icons/*.png ~/.local/share/icons/hicolor/48x48/apps/ 2>/dev/null
    find ~/.local/share/applications/icons/ -xtype l -delete
}

function albert() {
    mkdir -p ~/.config/albert/
    link-file "$ROOT_DIR" '.config/albert/albert.conf'
}


function cleanup() {
    echo "cleanup"
}

# shellcheck source=../.autobash
source "$ROOT_DIR/.autobash"
