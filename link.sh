#!/usr/bin/env bash

# shellcheck disable=SC2230
# shellcheck disable=SC2155

if [[ $UID -eq 0 ]]; then
	echo "Run this script as non root user please..."
	exit 99
fi


DIR=
if [[ -n $BASH_SOURCE ]]; then
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	cd "$DIR" || exit 1
fi

set -eu



function is_ubuntu() {
	[[ $(lsb_release -s -i 2>/dev/null) = 'Ubuntu' ]]
}

function is_android() {
	#pidof com.android.phone &>/dev/null
	[[ $(uname -o) = 'Android' ]]
}

function is_linux() {
	[[ $(uname) = 'Linux' ]]
}



remove_wine_desktop_files() {
	find "$HOME/.local/share/applications/" | sort \
		| grep wine-extension \
		| grep -v application.desktop \
		| grep -v appref-ms \
		| grep -v vbs \
		| grep -v msp \
		| grep -v hlp \
		| grep -v url \
		| xargs -I {} rm {}
}

create_remmina_desktop_files() {
	find ~/.local/share/applications/ -type f -name 'remmina-connection-*' | while read -r file; do
		rm "$file"
	done
	if [ ! -d ~/.remmina ]; then
		return
	fi
	find ~/.remmina -type f -name '*.remmina' | while read -r file; do
		name="$(grep '^name=' "$file" | cut -d'=' -f2)"
		name_formatted=$(echo "$name" | sed -E 's/[^a-zA-Z0-9]/_/g')
		cat <<EOL | tee ~/.local/share/applications/remmina-connection-"$name_formatted".desktop >/dev/null
[Desktop Entry]
Name=Remmina - $name
Exec=remmina -c $file
Icon=remmina
Type=Application
Categories=GTK;GNOME;X-GNOME-NetworkSettings;Network;
EOL
	done
}



function link-file() {
	dir="$1"
	# file relative to root folder
	arg="$2"
	source="${dir}/$arg"
	target="${HOME}/$arg"

	# Optional third argument to override the targer
	if [[ $# -eq 3 ]]; then
		target="$3"
	fi

	if [[ $arg = '' ]]; then
		echo "You need to provide source folder as first parameter"
		exit 1
	fi

	if [ ! -f "$source" ] && [ ! -d "$source" ]; then
		echo "File or folder '$source' ($target) does not exist!"
		exit 2
	fi

	rm -rf "$target"
	mkdir -p "$(dirname "$target")"
	ln -sf "$source" "$target"
}


mkdir -p ~/.local/share/xfpanel-switch
mkdir -p ~/.config/{copyq,ulauncher,Thunar}
mkdir -p ~/Screenshots


function vim() {
    {
        set +e
        link-file "$DIR" ".vimrc"
        link-file "$DIR" ".config/nvim"
        mkdir -p ~/.vim/{sessions,undo-dir,bundle,view,autoload}

        ln -sf "${DIR}"/.vim/autoload/* ~/.vim/autoload/
        # remove broken links
        find ~/.vim/autoload/ -xtype l -delete

        link-file "$DIR" ".vim/coc-settings.json"
        link-file "$DIR" ".vim/ftplugin"

        find ~/.vim/bundle -maxdepth 1 -type d ! -path . -print0 | xargs -0 -r -i bash -c "cd {}/.git 2>/dev/null; cd ..; git pull -q; exit 0"
        # command vim -c 'CocInstall -sync coc-highlight coc-json coc-html coc-phpls coc-python coc-markdownlint |q'
    }
}


function tmux() {
    {
        set +e
        link-file "$DIR" '.byobu'

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
    link-file "$DIR" ".config/Thunar/uca.xml"

    mkdir -p ~/.config/xfce4/
    link-file "$DIR" ".config/xfce4/terminal"
}

function icons() {
    mkdir -p ~/.local/share/applications/icons

    link-file "$DIR" '.local/share/applications/icons'
    ln -sf "${DIR}"/.local/share/applications/*.desktop ~/.local/share/applications/
    # remove broken links
    find ~/.local/share/applications/ -xtype l -delete
    mkdir -p ~/.local/share/icons/hicolor/48x48/apps/
    ln -sf "${DIR}"/.local/share/applications/icons/*.png ~/.local/share/icons/hicolor/48x48/apps/ 2>/dev/null
    find ~/.local/share/applications/icons/ -xtype l -delete
}

function albert() {
    mkdir -p ~/.config/albert/
    link-file "$DIR" '.config/albert/albert.conf'
}


function cleanup() {
    echo "cleanup"
}




mkdir -p ~/.config/{copyq,ulauncher,Thunar}
mkdir -p ~/Screenshots

link-file "$DIR" "audio"
link-file "$DIR" ".alsoftrc"
link-file "$DIR" ".config/gtk-3.0/gtk.css"
link-file "$DIR" ".config/clipit/clipitrc"

link-file "$DIR" ".config/copyq/copyq.conf"
link-file "$DIR" ".config/copyq/copyq-commands.ini"



# cp ~/{,dotfiles/}.config/Thunar/uca.xml
link-file "$DIR" ".config/Thunar/uca.xml"

link-file "$DIR" ".config/neofetch/config.conf"
link-file "$DIR" ".config/tilda"

link-file "$DIR" ".spacemacs"
link-file "$DIR" ".imwheelrc"


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
# chmod +x -R ~/bin/ &>/dev/null
if [[ -d ~/bin/bin ]]; then
	rm -rf ~/bin/bin
fi


if [[ ! -d ~/.fzf ]] && ! is_android
then
	git clone --depth 1 -q https://github.com/junegunn/fzf.git ~/.fzf
	yes | ~/.fzf/install >/dev/null
fi


link-file "$DIR" '.functions'
link-file "$DIR" '.ncmpcpp'
link-file "$DIR" '.config/vis'
link-file "$DIR" '.config/alacritty'
link-file "$DIR" '.skyscraper'
mkdir -p ~/.config/cmus
link-file "$DIR" '.config/cmus/rc'
mkdir -p ~/.config/pulse
link-file "$DIR" '.config/pulse/client.conf'
link-file "$DIR" '.zshrc'

icons

link-file "$DIR" '.mpdconf'


link-file "$DIR" '.config/Code/User/keybindings.json'

xfce
vim
tmux

if [[ -f "$DIR/installers/apps/oh-my-zsh.sh" ]]; then
	bash "$DIR/installers/apps/oh-my-zsh.sh"
fi

create_remmina_desktop_files

if command -V sudo &>/dev/null && [[ ! -f /etc/profile.d/homedir-path.sh ]]; then
	sudo ln -sf "$DIR/profile.d/homedir-path.sh" /etc/profile.d/homedir-path.sh
fi

if is_android
then
	mkdir -p ~/.config/openbox

	link-file "$DIR" 'termux/.config/openbox' '.config/openbox'
	link-file "$DIR" 'termux/.vnc' '.vnc'
	link-file "$DIR" 'termux/bin' 'termux_bin'

	# installFontsFromZip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Iosevka.zip Iosevka
	# cp ~/.local/share/fonts/Iosevka/Iosevka\ Term\ Nerd\ Font\ Complete\ Mono.ttf ~/.termux/font.ttf

	mkdir -p "$HOME/.local/share/fonts/Jetbrains Mono"
	curl -LsS https://github.com/JetBrains/JetBrainsMono/raw/8f764465dd71567dca8c547fbac23663cedd867c/ttf-nerdfont-patched/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.ttf -o "$HOME/.local/share/fonts/Jetbrains Mono/Jetbrains Mono Regular Nerd Font Complete Mono.ttf"
	cp "$HOME/.local/share/fonts/Jetbrains Mono/Jetbrains Mono Regular Nerd Font Complete Mono.ttf" ~/.termux/font.ttf
fi


if [[ ! -d ~/src/splatmoji ]]; then
	mkdir -p ~/src
	cd ~/src
	git clone -q https://github.com/cspeterson/splatmoji.git
fi
