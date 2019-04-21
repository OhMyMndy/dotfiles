#!/usr/bin/env bash

if [ $UID -eq 0 ]; then
    echo "Run this script as non root user please..."
    exit 99
fi


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/.functions"
source "$DIR/.zshrc" 2>/dev/null


mkdir -p ~/.config
mkdir -p ~/Screenshots


link-file "$DIR" ".vimrc"

mkdir -p ~/.config/xfce4/
link-file "$DIR" ".config/xfce4/terminal"
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
link-file "$DIR" '.screenlayout'
link-file "$DIR" 'z.sh'
link-file "$DIR" '.mpdconf'
link-file "$DIR" '.myclirc'
link-file "$DIR" '.gemrc'
link-file "$DIR" '.dircolors'

touch ~/.z

link-file "$DIR" '.config/beets'


if [ ! -d ~/bin_bak ]; then
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
$HOME/.tmux/plugins/tpm/bin/install_plugins


if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

yes | vim +PluginInstall +qall



#cd $DIR
#installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Hack.zip" "Hack"
#installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/UbuntuMono.zip" "UbuntuMono"
#installFontsFromZip "https://github.com/sgolovine/PlexNerdfont/archive/master.zip" "IBM-Plex-Mono-NerdFont"
#rm -rf ~/.local/share/fonts/IBM-Plex/originals
#rm -rf ~/.local/share/fonts/IBM-Plex/windows-compatable
#installFontsFromZip "https://github.com/IBM/plex/releases/download/v1.1.6/OpenType.zip" "IBM-Plex"
#installFontsFromZip "http://dl.1001fonts.com/ubuntu.zip" "Ubuntu"
#
installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraMono.zip FiraMonoNerdFont
installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Hack.zip HackNerdFont
installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/SourceCodePro.zip SourceCodeProNerdFont
if [ $fontsAdded -eq 1 ]; then
	fc-cache -f -v
fi

bash "$DIR/installers/oh-my-zsh.sh"

create_remmina_desktop_files