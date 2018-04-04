#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/.functions
source $DIR/.zshrc 2>/dev/null

dark_mode=$(cat $HOME/.dark-mode 2>/dev/null)

source ~/.functions

mkdir -p ~/.config
mkdir -p ~/Screenshots

rm -f ~/.startup.sh
ln -sf ${DIR}/.startup.sh ~/.startup.sh

rm -f ~/.vimrc
ln -sf ${DIR}/.vimrc ~/.vimrc

rm -f ~/.dircolors
ln -sf ~/dotfiles/.dircolors ~/.dircolors

rm -rf ~/.vim
ln -sf ${DIR}/.vim ~/.vim

rm -f ~/.config/redshift.conf
ln -sf ${DIR}/.config/redshift.conf ~/.config/redshift.conf

rm -rf ~/.config/i3
ln -sf ${DIR}/.config/i3 ~/.config/i3

rm -rf ~/.config/openbox
ln -sf ${DIR}/.config/openbox ~/.config/openbox

mkdir -p ${DIR}/.config/xfce4/xfconf/xfce-perchannel-xml
ln -sf ${DIR}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml

rm -rf ~/.config/xfce4/terminal
ln -sfn ${DIR}/.config/xfce4/terminal ~/.config/xfce4/terminal

rm -rf ~/.config/Thunar/uca.xml
ln -sfn ${DIR}/.config/Thunar/uca.xml ~/.config/Thunar/uca.xml

rm -rf ~/.config/parcellite/parcelliterc
mkdir -p ~/.config/parcellite/
ln -sfn ${DIR}/.config/parcellite/parcelliterc  ~/.config/parcellite/parcelliterc


ln -sf ${DIR}/.wallpaper.jpg ~/.wallpaper.jpg

rm -rf ~/.config/gtk-3.0
ln -sf ${DIR}/.config/gtk-3.0 ~/.config/gtk-3.0

rm -rf ~/.config/qt5ct
ln -sf ${DIR}/.config/qt5ct ~/.config/qt5ct

rm -rf ~/.conkyrc
ln -sf ${DIR}/.conkyrc ~/.conkyrc

rm -rf ~/.config/conky
ln -sf ${DIR}/.config/conky ~/.config/conky

rm -rf ~/.synergy.conf
ln -sf ${DIR}/.synergy.conf ~/.synergy.conf

rm -f ~/.screenrc
ln -sf ${DIR}/.screenrc ~/.screenrc

rm -rf ~/.config/terminator
ln -sf ${DIR}/.config/terminator ~/.config/terminator

rm -rf ~/.config/polybar
ln -sf ${DIR}/.config/polybar ~/.config/polybar

rm -rf ~/.config/byobu
ln -sf ${DIR}/.byobu ~/.config/byobu

rm -rf ~/.byobu
ln -sf ${DIR}/.byobu ~/.byobu

rm -rf ~/.config/fontconfig
ln -sf ${DIR}/.config/fontconfig ~/.config/fontconfig

rm -f ~/.yaourtrc
ln -sf ${DIR}/.yaourtrc ~/.yaourtrc

rm -rf ~/.config/mopidy
ln -sf ${DIR}/.config/mopidy ~/.config/mopidy

rm -rf ~/.config/htop
ln -sf ${DIR}/.config/htop ~/.config/htop

rm -rf ~/.screenlayout
ln -sf ${DIR}/.screenlayout ~/.screenlayout

rm -f ~/z.sh
ln -sf ${DIR}/z.sh ~/z.sh

rm -f ~/.xinitrc
ln -sf ${DIR}/.xinitrc ~/.xinitrc

rm -rf ~/wallpapers
ln -sf ${DIR}/wallpapers ~/wallpapers

rm -rf ~/.cheat
ln -sf ${DIR}/.cheat ~/.cheat

rm -rf ~/commands.txt
ln -sf ${DIR}/commands.txt ~/commands.txt

rm -rf ~/.mpdconf
ln -sf ${DIR}/.mpdconf ~/.mpdconf

rm -rf ~/.myclirc
ln -sf ${DIR}/.myclirc ~/.myclirc

touch ~/.z


#sudo mkdir -p /etc/lightdm
#sudo rm -f /etc/lightdm/lightm.conf
#sudo cp ~/dotfiles/etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf


rm -f ~/.config/compton.conf
ln -sf ${DIR}/.config/compton.conf ~/.config/compton.conf

rm -rf ~/.config/beets
ln -sf ${DIR}/.config/beets ~/.config/beets

rm -rf ~/.config/ranger
ln -sf ${DIR}/.config/ranger ~/.config/ranger

if [ ! -d ~/bin_bak ]; then
	mv -f ~/bin ~/bin_bak
fi

rm -rf ~/bin
ln -sf ${DIR}/bin ~/bin
chmod +x -R ~/bin/
rm -rf ~/bin/bin


mkdir -p ~/.tmux

ln -sf ~/.byobu/.tmux.conf ~/.tmux.conf

rm -f ~/.apm-packages
ln -sf ${DIR}/.apm-packages ~/.apm-packages

rm -f ~/.imwheelrc
ln -sf ${DIR}/.imwheelrc ~/.imwheelrc

rm -f ~/.inputrc
ln -sf ${DIR}/.inputrc ~/.inputrc

ln -sf ${DIR}/.functions ~/.functions


rm -f ~/.config/udiskie/config.yml
mkdir -p ~/.config/udiskie
ln -sf ${DIR}/.config/udiskie/config.yml ~/.config/udiskie/config.yml


rm -rf ~/.config/peco
ln -sf ${DIR}/.config/peco ~/.config/peco

rm -rf ~/.config/Trolltech.conf
ln -sf ${DIR}/.config/Trolltech.conf ~/.config/Trolltech.conf


if [ ! -f ~/.config/mimeapps.list_bak ]; then
	cp ~/.config/mimeapps.list ~/.config/mimeapps.list_bak
fi

if [ ! -f ~/.local/share/applications/mimeapps.list_bak ]; then
	cp ~/.local/share/applications/mimeapps.list ~/.local/share/applications/mimeapps.list_bak
fi


rm -rf ~/.config/mimeapps.list
ln -sf ${DIR}/.config/mimeapps.list ~/.config/mimeapps.list

rm -rf ~/.local/share/applications/mimeapps.list
ln -s ~/.config/mimeapps.list ~/.local/share/applications/mimeapps.list

rm -f ~/.fonts.conf
ln -sf ${DIR}/.fonts.conf ~/.fonts.conf


rm -rf ~/.distro-logos
ln -sf ${DIR}/.distro-logos ~/.distro-logos


mkdir -p ~/.teamocil
ln -sf ${DIR}/.teamocil/* ~/.teamocil/

rm -rf ~/.ncmpcpp
ln -sf ${DIR}/.ncmpcpp ~/.ncmpcpp

rm -rf ~/.config/vis
ln -sf ${DIR}/.config/vis ~/.config/vis

##### START DESKTOP FILES #####

mkdir -p ~/.local/share/applications/icons

rm -rf ~/.local/share/applications/icons
ln -sf ${DIR}/.local/share/applications/icons ~/.local/share/applications/icons

ln -sf ${DIR}/.local/share/applications/*.desktop ~/.local/share/applications/

mkdir -p ~/.local/share/icons/hicolor/48x48/apps/
ln -s ${DIR}/.local/share/applications/icons/*.png ~/.local/share/icons/hicolor/48x48/apps/ 2>/dev/null


##### END DESKTOP FILES #####


rm -rf ~/dockerFiles
ln -sf  ${DIR}/dockerFiles ~/dockerFiles

rm -rf ~/.config/powerline
ln -sf  ${DIR}/.config/powerline ~/.config/powerline

touch ~/custom_commands.txt

rm -rf ~/.mpdconf
ln -sf  ${DIR}/.mpdconf ~/.mpdconf

rm -rf ~/.config/albert/albert.conf
mkdir -p ~/.config/albert/
ln -sf  ${DIR}/.config/albert/albert.conf ~/.config/albert/albert.conf

rm -rf ~/.config/volumeicon/volumeicon
mkdir -p ~/.config/volumeicon/
ln -sf  ${DIR}/.config/volumeicon/volumeicon ~/.config/volumeicon/volumeicon



if [ "$dark_mode" = "1" ]; then
	sed -E -i 's/one-light/one-dark/g' ~/.atom/config.cson > /dev/null 2>&1
else
	sed -E -i 's/one-dark/one-light/g' ~/.atom/config.cson > /dev/null 2>&1
fi


if [ ! -d ~/.oh-my-zsh/lib ]; then
    rm -rf ~/.oh-my-zsh/
    cd /tmp
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh
    sed -i.tmp 's:env zsh::g' install.sh
    sed -i.tmp 's:chsh -s .*$::g' install.sh
    sh install.sh
    rm install.sh
fi

if [ -d ~/.oh-my-zsh/custom ]; then
    mkdir -p ~/.oh-my-zsh/custom/themes
    ln -sf ${DIR}/.oh-my-zsh/custom/themes/mandy.zsh-theme ~/.oh-my-zsh/custom/themes/mandy.zsh-theme
fi

rm -f ~/.zshrc
ln -sf ${DIR}/.zshrc ~/.zshrc


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

set -e
#installJetbrainsPlugin 'IDEA-C' '1293-ruby'


installZshPlugin "git://github.com/zsh-users/zsh-autosuggestions" "zsh-autosuggestions"
installZshPlugin "https://github.com/zsh-users/zsh-completions" "zsh-completions"
installZshPlugin "https://github.com/zsh-users/zsh-syntax-highlighting.git" "zsh-syntax-highlighting"
installZshPlugin "https://github.com/jimeh/zsh-peco-history.git" "zsh-peco-history"
sed -i -e's/\s*BUFFER=.*/BUFFER=$\(fc -l -n 1 |  eval $tac | awk "\!x\[\\$0\]++" | \\/' ~/.oh-my-zsh/custom/plugins/zsh-peco-history/zsh-peco-history.zsh


installZshPlugin "https://github.com/skx/sysadmin-util.git" "sysadmin-util"

# if [ ! -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]; then
	# git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
	# ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
#fi

# installZshTheme "https://raw.githubusercontent.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme" "bullet-train.zsh-theme"

# Regular fonts
installFontsFromZip "https://www.wfonts.com/download/data/2016/05/11/gill-sans-std/gill-sans-std.zip" "GillSans"

installFontsFromZip "https://github.com/RedHatBrand/Overpass/releases/download/3.0.2/overpass-desktop-fonts.zip" "overpass"
if [ "$(uname)" != 'Darwin' ]; then
	installFontsFromZip "https://github.com/AppleDesignResources/SanFranciscoFont/archive/master.zip" "sanfrancisco"
fi
installFontsFromZip "http://dl.1001fonts.com/alte-din-1451-mittelschrift.zip" "din-1451"
installFontsFromZip "https://github.com/KDE/oxygen-fonts/archive/master.zip" "oxygen"
# installFontsFromZip "https://www.fontsquirrel.com/fonts/download/archivo-narrow" "archivo-narrow"
# installFontsFromZip "https://www.fontsquirrel.com/fonts/download/TeX-Gyre-Heros" "text-gyre-heros"
installFontsFromZip "https://dl.dafont.com/dl/?f=liberation_sans" "liberation-sans"
installFontsFromZip "https://www.fontsquirrel.com/fonts/download/montserrat" "montserrat"
installFontsFromZip "https://www.wfonts.com/download/data/2015/03/12/futura/futura.zip" "Futura"
installFontsFromZip "https://www.wfonts.com/download/data/2015/06/23/frutiger/frutiger.zip" "Frutiger"

# Monospaced fonts
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/FiraMono.zip" "FiraMono"
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/DroidSansMono.zip" "DroidSansMono"
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/FantasqueSansMono.zip" "FantasqueSansMono"
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/Inconsolata.zip" "Inconsolata"
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/Meslo.zip" "Meslo"
# installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/RobotoMono.zip" "RobotoMono"
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/AnonymousPro.zip" "AnonymousPro"
# installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/SpaceMono.zip" "SpaceMono"
# installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/Terminus.zip" "Terminus"
# installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/Mononoki.zip" "Monoki"
# installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/ProFont.zip" "ProFont"
# installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/ProggyClean.zip" "ProggyClean"
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/Hack.zip" "Hack"
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/Iosevka.zip" "Iosevka"
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/UbuntuMono.zip" "UbuntuMono"
installFontsFromZip "http://www.fontspace.com/download/6269/e70447f0601e46ecbea2dc3bf9f59695/prismtone_ptf-nordic.zip" "PrismtoneNordic"



if [ $fontsAdded -eq 1 ]; then
	fc-cache -f -v
fi

installGtkTheme "https://github.com/B00merang-Project/macOS-Sierra/archive/master.zip" "macOS-Sierra"
installGtkTheme "https://github.com/B00merang-Project/Windows-10/archive/master.zip" "Windows-10"
installGtkTheme "https://github.com/Elbullazul/Redmond-Themes/releases/download/2016%2F11%2F15/Windows.3.x.R4.zip" "Windows-3.x"
installGtkTheme "https://github.com/B00merang-Project/Android/archive/master.zip" "Boomerang-Android"
installGtkTheme "https://github.com/B00merang-Project/Fushia/archive/master.zip" "Boomerang-Android-Fushia"
installGtkTheme "https://github.com/B00merang-Project/Chrome-OS/archive/master.zip" "Boomerang-Chrome-OS"

set +e

installPeco
# Execute executables in Thunar instead of editing them on double click: https://bbs.archlinux.org/viewtopic.php?id=194464
xfconf-query --channel thunar --property /misc-exec-shell-scripts-by-default --create --type bool --set true

crontab -l 2>/dev/null | grep -q "$HOME/bin/disk-usage-warning"
inCrontab=$?

if [ "${inCrontab}" == "1" ]; then
	(crontab -l 2>/dev/null; echo "*/5 * * * * export DISPLAY=:0 && $HOME/bin/disk-usage-warning 2>&1 > /dev/null") | crontab -
fi


mkdir -p $HOME/.ssh/sockets
sudo -A chown -R mandy:mandy $HOME/.ssh
touch $HOME/.ssh/config
chmod 600 $HOME/.ssh/config

function sedeasy {
    sed -i "s/.*$(echo $1 | sed -e 's/\([[\/.*]\|\]\)/\\&/g').*$/$(echo $2 | sed -e 's/[\/&]/\\&/g')/g" $3
}

function addToProfile() {
    var="$1"
    value="$2"

    newline="export $var=$value"
    if grep -q "export $var=" ~/.profile; then
        sedeasy "export $var=" "$newline" ~/.profile
    else
        echo "$newline" | tee -a ~/.profile >/dev/null
    fi
}

addToProfile 'IP_ADDRESS' '$(ip -4 route get 1 | head -1 | awk "{print \$7}" )'
addToProfile 'GID' '$(id -g)'
addToProfile 'DOCKER_GID' '$(getent group docker 2>/dev/null | cut -d: -f3 )'
addToProfile 'XDG_CONFIG_HOME' '$HOME/.config'
addToProfile 'QT_QPA_PLATFORMTHEME' "qt5ct"
addToProfile '_JAVA_OPTIONS' "-Dawt.useSystemAAFontSettings=on"

# sudo chown root:mandy /etc/default/locale
# sudo chmod 664 /etc/default/locale
#
# cat <<'EOL' | sudo tee /etc/locale.conf
# LANG=en_US.UTF-8
# LANGUAGE="en_US.UTF-8"
# LC_CTYPE="en_US.UTF-8"
# LC_NUMERIC="nl_BE.UTF-8"
# LC_TIME="nl_BE.UTF-8"
# LC_COLLATE="en_US.UTF-8"
# LC_MONETARY="nl_BE.UTF-8"
# LC_MESSAGES="en_US.UTF-8"
# LC_PAPER="nl_BE.UTF-8"
# LC_NAME="nl_BE.UTF-8"
# LC_ADDRESS="nl_BE.UTF-8"
# LC_TELEPHONE="nl_BE.UTF-8"
# LC_MEASUREMENT="nl_BE.UTF-8"
# LC_IDENTIFICATION="nl_BE.UTF-8"
#
# EOL

pstorm="$(locate phpstorm.sh | tail -1)"
if [ "$pstorm" != '' ]; then
	sudo -A ln -sf "$pstorm" /usr/bin/pstorm
fi

# remove arc border radius

find /usr/share/themes/Arc -type f -name '*.rc' | sudo xargs -I {} sed -E -i 's/(radius\s*=)([^;]+)/\1 0/g' {}
find /usr/share/themes/Arc -type f -name '*.css' | sudo xargs -I {} sed -E -i 's/(border.+radius:)([^;]+);/\1 0px;/g' {}

if [ ! -d "$HOME/.nvm" ]; then
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
	sudo -A chown -R $USER:"$(id -gn $USER)" $HOME/.config
	nvm install stable
fi

if ! grep -q '192.168.10.120/tank' /etc/fstab; then
	echo "Please enter password of 192.168.10.120/tank"
	read -s password
	echo "//192.168.10.120/tank /mnt/tank cifs rw,_netdev,user=mandy,password=${password},uid=$(id -u mandy),gid=$(id -g mandy) 0 0" | sudo -A tee -a /etc/fstab >/dev/null
fi


remove_wine_desktop_files

create_remmina_desktop_files

# Fix for Intellij platform editors on i3wm @see https://faq.i3wm.org/question/4071/modal-pop-up-in-idea-loses-focus-while-entering-text.1.html
locate idea.properties | xargs -I {} sed -E -i 's/#?idea.popup.weight=.*$/idea.popup.weight=medium/g' "{}"
