#!/usr/bin/env bash



trap "exit" INT


if [[ $UID -eq 0 ]]; then
	echo "Run this script as non root user please..."
	exit 99
fi


fontsAdded=0

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR" || exit 1
ROOT_DIR="$(git rev-parse --show-toplevel)"


mkdir -p ~/.local/share/xfpanel-switch
mkdir -p ~/.config/{copyq,ulauncher,Thunar}
mkdir -p ~/Screenshots
mkdir -p ~/.local/share/applications/icons


# shellcheck source=../.functions
source "$ROOT_DIR/.functions"

function vim() {
    link-file "$ROOT_DIR" ".vimrc"
    link-file "$ROOT_DIR" ".config/nvim"
    mkdir -p ~/.vim/{sessions,undo-dir,bundle,view,autoload}

    ln -sf "${ROOT_DIR}"/.vim/autoload/* ~/.vim/autoload/
    # remove broken links
    find ~/.vim/autoload/ -xtype l -delete

    link-file "$ROOT_DIR" ".vim/coc-settings.json"

    # vim -c 'CocInstall -sync coc-highlight coc-json coc-html coc-phpls coc-python coc-markdownlint |q'
}


function tmux() {
    link-file "$ROOT_DIR" '.byobu'
    mkdir -p ~/.tmux/plugins
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins
    fi
    $(command tmux) source ~/.tmux.conf

    # shellcheck disable=SC1091
    # shellcheck source=/dev/null
    source "$HOME/.tmux/plugins/tpm/bin/install_plugins"
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
    ln -s "${ROOT_DIR}"/.local/share/applications/icons/*.png ~/.local/share/icons/hicolor/48x48/apps/ 2>/dev/null
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
