#!/usr/bin/env bash

# shellcheck disable=SC2230
# shellcheck disable=SC2155

if [ $UID -eq 0 ]; then
	echo "Run this script as non root user please..."
	exit 99
fi

trap "exit" INT


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=.functions
source "$DIR/.functions"

# shellcheck source=.zshrc
source "$DIR/.zshrc" 2>/dev/null


mkdir -p ~/.config/{copyq,ulauncher,Thunar}
mkdir -p ~/Screenshots

link-file "$DIR" ".config/copyq/copyq.conf"
link-file "$DIR" ".config/copyq/copyq-commands.ini"


link-file "$DIR" ".config/Thunar/uca.xml"

link-file "$DIR" ".spacemacs"


link-file "$DIR" ".config/compton"
link-file "$DIR" ".config/MusicBrainz"

link-file "$DIR" ".config/ulauncher/shortcuts.json"
link-file "$DIR" ".config/ulauncher/settings.json"
link-file "$DIR" ".config/ulauncher/extensions.json"

if [ ! -f ~/.Xresources_bak ] && [ -f ~/.Xresources ]; then
	cp ~/.Xresources ~/.Xresources_bak
fi
link-file "$DIR" ".Xresources"



mkdir -p ~/.local/share/xfpanel-switch/
cp -f $DIR/.local/share/xfpanel-switch/*  ~/.local/share/xfpanel-switch/

link-file "$DIR" '.config/fontconfig'
link-file "$DIR" '.config/parcellite'
link-file "$DIR" ".config/i3"
link-file "$DIR" ".config/polybar"
link-file "$DIR" ".config/rofi"
link-file "$DIR" ".config/quicktile.cfg"
link-file "$DIR" ".config/redshift.conf"

link-file "$DIR" ".lessrc"
link-file "$DIR" ".face"


## PLASMA
link-file "$DIR" '.config/klipperrc'
link-file "$DIR" '.config/plasma-localerc'
## PLASMA END


link-file "$DIR" '.synergy.conf'
link-file "$DIR" '.dircolors'
link-file "$DIR" '.screenrc'

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
link-file "$DIR" '.config/redshift.conf'


if [ ! -d ~/bin_bak ] && [ -d ~/bin ]; then
	mv -f ~/bin ~/bin_bak
fi
link-file "$DIR" 'bin'
chmod +x -R ~/bin/
rm -rf ~/bin/bin


if ! which fzf >/dev/null 2>&1
then
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	yes | ~/.fzf/install
fi
mkdir -p ~/.tmux
ln -sf ~/.byobu/.tmux.conf ~/.tmux.conf

link-file "$DIR" '.functions'
link-file "$DIR" '.ncmpcpp'
link-file "$DIR" '.config/vis'
link-file "$DIR" '.config/alacritty'
mkdir -p ~/.config/cmus
link-file "$DIR" '.config/cmus/rc'
link-file "$DIR" '.zshrc'

bash "$DIR/installers/config.sh" --icons

link-file "$DIR" '.mpdconf'



bash "$DIR/installers/config.sh" --xfce
bash "$DIR/installers/config.sh" --vim
bash "$DIR/installers/config.sh" --tmux

bash "$DIR/installers/apps/oh-my-zsh.sh"

create_remmina_desktop_files

if [[ ! -f /etc/profile.d/homedir-path.sh ]]; then
	sudo ln -sf "$DIR/profile.d/homedir-path.sh" /etc/profile.d/homedir-path.sh
fi

if [[ $(uname -o) = 'Android' ]];
then
	mkdir -p ~/.config/openbox

	link-file "$DIR" 'termux/.config/openbox' '.config/openbox'
	link-file "$DIR" 'termux/.vnc' '.vnc'

	installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Iosevka.zip Iosevka
	cp ~/.local/share/fonts/Iosevka/Iosevka\ Term\ Nerd\ Font\ Complete\ Mono.ttf ~/.termux/font.ttf
fi


if [[ ! -f /etc/sudoers.d/expressvpn ]]; then
	echo "Adding expressvpn rule to sudoers file"
	echo "%sudo ALL=(root) NOPASSWD: /home/mandy/bin/expressvpn-mandy" | sudo tee /etc/sudoers.d/expressvpn &>/dev/null
fi

if [[ ! -d ~/src/splatmoji ]]; then
	mkdir -p ~/src
	cd ~/src
	git clone https://github.com/cspeterson/splatmoji.git
	cd splatmoji
	curl 'https://raw.githubusercontent.com/muan/emojilib/master/emojis.json' | importers/emojilib2tsv - > data/emoji.tsv
	curl 'https://raw.githubusercontent.com/w33ble/emoticon-data/master/emoticons.json' | importers/w33ble2tsv - > data/emoticons.tsv
fi
