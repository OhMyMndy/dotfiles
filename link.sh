#!/usr/bin/env bash

if [ $UID -eq 0 ]; then
    echo "Run this script as non root user please..."
    exit 99
fi


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=.functions
source "$DIR/.functions"
# shellcheck source=.zshrc
source "$DIR/.zshrc" 2>/dev/null


mkdir -p ~/.config
mkdir -p ~/Screenshots


link-file "$DIR" ".vimrc"
link-file "$DIR" ".spacemacs"


if [ ! -f ~/.Xresources_bak ] && [ -f ~/.Xresources ]; then
	cp ~/.Xresources ~/.Xresources_bak
fi
link-file "$DIR" ".Xresources"

mkdir -p ~/.config/xfce4/
link-file "$DIR" ".config/xfce4/terminal"


mkdir -p ~/.local/share/xfpanel-switch/
cp -f $DIR/.local/share/xfpanel-switch/*  ~/.local/share/xfpanel-switch/

link-file "$DIR" '.config/fontconfig'
link-file "$DIR" ".config/i3"
link-file "$DIR" ".config/rofi"
link-file "$DIR" ".config/quicktile.cfg"
link-file "$DIR" ".lessrc"


## PLASMA
link-file "$DIR" '.config/klipperrc'
link-file "$DIR" '.config/plasma-localerc'
## PLASMA END


link-file "$DIR" '.synergy.conf'
link-file "$DIR" '.dircolors'
link-file "$DIR" '.screenrc'
link-file "$DIR" '.byobu'
link-file "$DIR" '.config/mopidy'
link-file "$DIR" '.config/htop'
# link-file "$DIR" '.toprc'
link-file "$DIR" 'z.sh'
link-file "$DIR" '.mpdconf'
link-file "$DIR" '.myclirc'
link-file "$DIR" '.gemrc'
link-file "$DIR" '.dircolors'

touch ~/.z

link-file "$DIR" '.config/beets'


if [ ! -d ~/bin_bak ] && [ -d ~/bin ]; then
	mv -f ~/bin ~/bin_bak
fi
link-file "$DIR" 'bin'
chmod +x -R ~/bin/
rm -rf ~/bin/bin


mkdir -p ~/.tmux
ln -sf ~/.byobu/.tmux.conf ~/.tmux.conf

link-file "$DIR" '.functions'
link-file "$DIR" '.ncmpcpp'
link-file "$DIR" '.config/vis'
link-file "$DIR" '.config/alacritty'
link-file "$DIR" '.zshrc'

##### START DESKTOP FILES #####
mkdir -p ~/.local/share/applications/icons

link-file "$DIR" '.local/share/applications/icons'
ln -sf ${DIR}/.local/share/applications/*.desktop ~/.local/share/applications/

mkdir -p ~/.local/share/icons/hicolor/48x48/apps/
ln -s ${DIR}/.local/share/applications/icons/*.png ~/.local/share/icons/hicolor/48x48/apps/ 2>/dev/null
##### END DESKTOP FILES #####


link-file "$DIR" '.mpdconf'

mkdir -p ~/.config/albert/
link-file "$DIR" '.config/albert/albert.conf'


mkdir -p ~/.tmux/plugins
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins
fi
tmux source ~/.tmux.conf
#shellcheck source=$HOME/.tmux/plugins/tpm/bin/install_plugins
source "$HOME/.tmux/plugins/tpm/bin/install_plugins"


if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

yes | vim +PluginInstall +qall

bash "$DIR/installers/apps/oh-my-zsh.sh"

create_remmina_desktop_files


# autostart files
mkdir -p ~/.config/autostart
ln -s ${DIR}/.config/autostart/*.desktop ~/.config/autostart/ 2>/dev/null

find /usr/share/applications -iname 'nextcloud.desktop' | xargs -I {} ln -s {} ~/.config/autostart
find /usr/share/applications -iname 'albert.desktop' | xargs -I {} ln -s {} ~/.config/autostart