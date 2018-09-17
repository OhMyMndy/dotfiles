#!/usr/bin/env bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/.functions"
source "$DIR/.zshrc" 2>/dev/null

dark_mode=$(cat $HOME/.dark-mode 2>/dev/null)


mkdir -p ~/.config
mkdir -p ~/Screenshots


link-file "$DIR" ".startup.sh"
link-file "$DIR" ".vimrc"
link-file "$DIR" ".vim"
link-file "$DIR" ".dircolors"
link-file "$DIR" ".config/redshift.conf"
link-file "$DIR"".config/i3"
link-file "$DIR" ".i3status.conf"
link-file "$DIR" ".config/openbox"
mkdir -p ${DIR}/.config/xfce4/xfconf/xfce-perchannel-xml
if  [ ! -L ".config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml" ]; then
    rm -f "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
    link-file "$DIR" ".config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
fi
if  [ ! -L ".config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml" ]; then
    rm -f "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml"
    link-file "$DIR" '.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml'
fi

mkdir -p ~/.config/Thunar
if  [ ! -L ".config/Thunar/uca.xml" ]; then
    rm -f "$HOME/.config/Thunar/uca.xml"
    link-file "$DIR" ".config/Thunar/uca.xml"
fi


mkdir -p ~/.config/xfce4/
link-file "$DIR" ".config/xfce4/terminal"

link-file "$DIR" ".config/Thunar/uca.xml"
mkdir -p ~/.config/parcellite/
link-file "$DIR" ".config/parcellite/parcelliterc"

link-file "$DIR" ".lessfilter"
link-file "$DIR" ".lessrc"


## PLASMA
#
#link-file "$DIR" '.config/khotkeysrc'
#link-file "$DIR" '.config/konsolerc'
#link-file "$DIR" '.local/share/konsole'
#link-file "$DIR" '.config/kdeglobals'
#link-file "$DIR" '.config/kscreenlockerrc'
#link-file "$DIR" '.config/klipperrc'
##link-file "$DIR" '.config/kcmshell5rc'
#
#
#link-file "$DIR" '.gtkrc-2.0'
#link-file "$DIR" '.gtkrc-2.0-kde-4'
#link-file "$DIR" '.config/gtk-3.0'
#link-file "$DIR" '.config/gtk-2.0'
#link-file "$DIR" '.config/gtkrc-2.0'
#link-file "$DIR" '.config/gtkrc'
#link-file "$DIR" '.config/kglobalshortcutsrc'
#
#link-file "$DIR" '.config/plasma-workspace'
#link-file "$DIR" '.config/plasma-localerc'
#link-file "$DIR" '.config/plasmashellrc'
#link-file "$DIR" '.config//plasma-org.kde.plasma.desktop-appletsrc'
## PLASMA END


link-file "$DIR" '.xscreensaver'
link-file "$DIR" '.config/qt5ct'
link-file "$DIR" '.conkyrc'
link-file "$DIR" '.config/conky'
link-file "$DIR" '.synergy.conf'
link-file "$DIR" '.screenrc'
link-file "$DIR" '.config/terminator'
link-file "$DIR" '.config/polybar'
link-file "$DIR" '.config/byobu'
link-file "$DIR" '.byobu'
link-file "$DIR" '.config/fontconfig'
link-file "$DIR" '.yaourtrc'
link-file "$DIR" '.config/mopidy'
link-file "$DIR" '.config/htop'
link-file "$DIR" '.screenlayout'
link-file "$DIR" 'z.sh'
link-file "$DIR" '.xinitrc'
link-file "$DIR" 'wallpapers'
link-file "$DIR" '.cheat'
link-file "$DIR" 'commands.txt'
link-file "$DIR" '.mpdconf'
link-file "$DIR" '.myclirc'
link-file "$DIR" '.gemrc'

touch ~/.z


#sudo mkdir -p /etc/lightdm
#sudo rm -f /etc/lightdm/lightm.conf
#sudo cp ~/dotfiles/etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf


link-file "$DIR" '.config/compton.conf'
link-file "$DIR" '.config/beets'
link-file "$DIR" '.config/ranger'

if [ ! -d ~/bin_bak ]; then
	mv -f ~/bin ~/bin_bak
fi
link-file "$DIR" 'bin'
chmod +x -R ~/bin/
rm -rf ~/bin/bin


mkdir -p ~/.tmux
ln -sf ~/.byobu/.tmux.conf ~/.tmux.conf

link-file "$DIR" '.apm-packages'
link-file "$DIR" '.imwheelrc'
link-file "$DIR" '.inputrc'
link-file "$DIR" '.functions'


rm -f ~/.config/udiskie/config.yml
link-file "$DIR" '.config/udiskie/config.yml'


link-file "$DIR" '.config/peco'
link-file "$DIR" '.config/Trolltech.conf'

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


link-file "$DIR" '.distro-logos'

mkdir -p ~/.teamocil
ln -sf ${DIR}/.teamocil/* ~/.teamocil/

link-file "$DIR" '.ncmpcpp'
link-file "$DIR" '.config/vis'
link-file "$DIR" '.config/tint2'

##### START DESKTOP FILES #####

mkdir -p ~/.local/share/applications/icons

link-file "$DIR" '.local/share/applications/icons'
ln -sf ${DIR}/.local/share/applications/*.desktop ~/.local/share/applications/

mkdir -p ~/.local/share/icons/hicolor/48x48/apps/
ln -s ${DIR}/.local/share/applications/icons/*.png ~/.local/share/icons/hicolor/48x48/apps/ 2>/dev/null


##### END DESKTOP FILES #####


link-file "$DIR" 'dockerFiles'
link-file "$DIR" '.config/powerline'
touch ~/custom_commands.txt

link-file "$DIR" '.mpdconf'
mkdir -p ~/.config/albert/
link-file "$DIR" '.config/albert/albert.conf'
mkdir -p ~/.config/volumeicon/
link-file "$DIR" '.config/volumeicon/volumeicon'


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

link-file "$DIR" '.zshrc'

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
#installFontsFromZip "https://www.wfonts.com/download/data/2016/05/11/gill-sans-std/gill-sans-std.zip" "GillSans"
#installFontsFromZip "https://github.com/erikflowers/weather-icons/archive/2.0.10.zip" "Weather-Icons"

cd /home/mandy/.local/share/fonts
git clone https://github.com/r4in/typefaces.git
cd $DIR

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
#installFontsFromZip "https://www.wfonts.com/download/data/2015/06/23/frutiger/frutiger.zip" "Frutiger"

# Monospaced fonts
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FiraMono.zip" "FiraMono"
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/DroidSansMono.zip" "DroidSansMono"
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/FantasqueSansMono.zip" "FantasqueSansMono"
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Inconsolata.zip" "Inconsolata"
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Meslo.zip" "Meslo"
# installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/RobotoMono.zip" "RobotoMono"
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/AnonymousPro.zip" "AnonymousPro"
# installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/SpaceMono.zip" "SpaceMono"
# installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Terminus.zip" "Terminus"
# installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Mononoki.zip" "Monoki"
# installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/ProFont.zip" "ProFont"
# installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/ProggyClean.zip" "ProggyClean"
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Hack.zip" "Hack"
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Iosevka.zip" "Iosevka"
installFontsFromZip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/UbuntuMono.zip" "UbuntuMono"
installFontsFromZip "https://github.com/sgolovine/PlexNerdfont/archive/master.zip" "IBM-Plex-Mono-NerdFont"
rm -rf ~/.local/share/fonts/IBM-Plex/originals
rm -rf ~/.local/share/fonts/IBM-Plex/windows-compatable
installFontsFromZip "https://github.com/IBM/plex/releases/download/v1.1.6/OpenType.zip" "IBM-Plex"

# installFontsFromZip "http://www.fontspace.com/download/6269/e70447f0601e46ecbea2dc3bf9f59695/prismtone_ptf-nordic.zip" "PrismtoneNordic"
installFontsFromZip "http://dl.1001fonts.com/ubuntu.zip" "Ubuntu"

#installFontsFromZip "https://dl.dafont.com/dl/?f=openlogos" "OpenLogos"
#installFontsFromZip "https://dl.dafont.com/dl/?f=pizzadude_bullets" "PizzaDude Bullets"
#installFontsFromZip "https://dl.dafont.com/dl/?f=style_bats" "StyleBats"
#installFont "https://fonts2u.com/download/pie-charts-for-maps.font" "Pie charts for maps"


if [ $fontsAdded -eq 1 ]; then
	fc-cache -f -v
fi

#installGtkTheme "https://github.com/B00merang-Project/macOS-Sierra/archive/master.zip" "macOS-Sierra"
#installGtkTheme "https://github.com/B00merang-Project/Windows-10/archive/master.zip" "Windows-10"
#installGtkTheme "https://github.com/Elbullazul/Redmond-Themes/releases/download/2016%2F11%2F15/Windows.3.x.R4.zip" "Windows-3.x"
#installGtkTheme "https://github.com/B00merang-Project/Android/archive/master.zip" "Boomerang-Android"
#installGtkTheme "https://github.com/B00merang-Project/Fushia/archive/master.zip" "Boomerang-Android-Fushia"
#installGtkTheme "https://github.com/B00merang-Project/Chrome-OS/archive/master.zip" "Boomerang-Chrome-OS"

set +e

# Execute executables in Thunar instead of editing them on double click: https://bbs.archlinux.org/viewtopic.php?id=194464
xfconf-query --channel thunar --property /misc-exec-shell-scripts-by-default --create --type bool --set true

crontab -l 2>/dev/null | grep -q "$HOME/bin/disk-usage-warning"
inCrontab=$?

if [ "${inCrontab}" == "1" ]; then
	(crontab -l 2>/dev/null; echo "*/5 * * * * export DISPLAY=:0 && $HOME/bin/disk-usage-warning 2>&1 > /dev/null") | crontab -
fi

crontab -l 2>/dev/null | grep -q "$HOME/bin/disk-io-warning"
inCrontab=$?
if [ "${inCrontab}" == "1" ]; then
	(crontab -l 2>/dev/null; echo "*/5 * * * * export DISPLAY=:0 && $HOME/bin/disk-io-warning 2>&1 > /dev/null") | crontab -
fi


mkdir -p $HOME/.ssh/sockets
#sudo -A chown -R mandy:mandy $HOME/.ssh
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
#addToProfile 'XDG_DATA_DIRS' '$XDG_DATA_DIRS:~/.local/share/flatpak/exports/share/applications:/var/lib/flatpak/exports/share/applications'




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
#if [ "$pstorm" != '' ]; then
	#sudo -A ln -sf "$pstorm" /usr/bin/pstorm
#fi

# remove arc border radius

#find /usr/share/themes/Arc -type f -name '*.rc' | sudo xargs -I {} sed -E -i 's/(radius\s*=)([^;]+)/\1 0/g' {}
#find /usr/share/themes/Arc -type f -name '*.css' | sudo xargs -I {} sed -E -i 's/(border.+radius:)([^;]+);/\1 0px;/g' {}



if ! grep -q '192.168.10.120/tank' /etc/fstab; then
	echo "Please enter password of 192.168.10.120/tank"
	read -s password
	echo "//192.168.10.120/tank /mnt/tank cifs rw,_netdev,user=mandy,password=${password},uid=$(id -u mandy),gid=$(id -g mandy) 0 0" | sudo -A tee -a /etc/fstab >/dev/null
fi


remove_wine_desktop_files

create_remmina_desktop_files

# Fix for Intellij platform editors on i3wm @see https://faq.i3wm.org/question/4071/modal-pop-up-in-idea-loses-focus-while-entering-text.1.html
locate idea.properties | xargs -I {} sed -E -i 's/#?.*idea.popup.weight=.*$/idea.popup.weight=medium/g' "{}"


# Chrome scaling factor
# sudo sed -Eri 's#(Exec=[a-zA-Z0-9/-]+)#\1 --force-device-scale-factor=0.9#g' $(locate google-chrome.desktop | head -1)
# sudo sed -Eri 's# --force-device-scale-factor=[0-9.]+##g' $(locate google-chrome.desktop | head -1)

#add-to-file "xinput --set-prop 'PixArt USB Optical Mouse' 'libinput Accel Speed' 0.3 2>/dev/null" "$HOME/.profile"
#add-to-file "xinput set-prop 'Razer Razer Abyssus' 287 0.8 2>/dev/null" "$HOME/.profile"
#add-to-file "xset s 300 360 2>/dev/null" "$HOME/.profile"



if [ ! -d "$HOME/polybar-scripts" ]; then
    cd "$HOME"; git clone https://github.com/x70b1/polybar-scripts.git
fi
