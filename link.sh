#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dark_mode=$(cat $HOME/.dark-mode 2>/dev/null)
echo "dark mode: $dark_mode"
#set -e

mkdir -p ~/.config

rm -f ~/.vimrc
ln -sf ${DIR}/.vimrc ~/.vimrc

rm -f ~/.dircolors
ln -sf ~/dotfiles/.dircolors ~/.dircolors

rm -rf ~/.vim
ln -sf ${DIR}/.vim ~/.vim

rm -f ~/.config/redshift.conf
ln -sf ${DIR}/.config/redshift.conf ~/.config/redshift.conf

rm -rf ~/.config/i3
ln -sfn ${DIR}/.config/i3 ~/.config/i3

ln -sf ${DIR}/.wallpaper.jpg ~/.wallpaper.jpg

rm -rf ~/.config/gtk-3.0
ln -sfn ${DIR}/.config/gtk-3.0 ~/.config/gtk-3.0


rm -rf ~/.conkyrc
ln -sf ${DIR}/.conkyrc ~/.conkyrc

rm -f ~/.screenrc
ln -sf ${DIR}/.screenrc ~/.screenrc

rm -rf ~/.config/terminator
ln -sf ${DIR}/.config/terminator ~/.config/terminator

rm -rf ~/.config/polybar
ln -sf ${DIR}/.config/polybar ~/.config/polybar

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

mv -f ~/bin ~/bin_old 2>/dev/null || echo "1" > /dev/null
rm -rf ~/bin
ln -sf ${DIR}/bin ~/bin
chmod +x -R ~/bin/


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

rm -f ~/.fonts.conf
ln -sf ${DIR}/.fonts.conf ~/.fonts.conf


rm -rf ~/.distro-logos
ln -sf ${DIR}/.distro-logos ~/.distro-logos

rm -rf ~/.local/share/applications/HeidiSQL.desktop
ln -sf ${DIR}/.local/share/applications/HeidiSQL.desktop ~/.local/share/applications/HeidiSQL.desktop

rm -rf ~/.local/share/applications/1Password.desktop
ln -sf ${DIR}/.local/share/applications/1Password.desktop ~/.local/share/applications/1Password.desktop

rm -rf ~/.local/share/applications/Wunderlist.desktop
ln -sf ${DIR}/.local/share/applications/Wunderlist.desktop ~/.local/share/applications/Wunderlist.desktop

rm -rf ~/dockerFiles
ln -sf  ${DIR}/dockerFiles ~/dockerFiles

rm -rf ~/.config/powerline
ln -sf  ${DIR}/.config/powerline ~/.config/powerline

touch ~/custom_commands.txt

if [ "$dark_mode" = "1" ]; then
	sed -E -i 's/one-light/one-dark/g' ~/.atom/config.cson > /dev/null 2>&1
else
	sed -E -i 's/one-dark/one-light/g' ~/.atom/config.cson > /dev/null 2>&1
fi


if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

mkdir -p ~/.oh-my-zsh/custom/themes
ln -sf ${DIR}/.oh-my-zsh/custom/themes/mandy.zsh-theme ~/.oh-my-zsh/custom/themes/mandy.zsh-theme


rm -f ~/.zshrc
ln -sf ${DIR}/.zshrc ~/.zshrc


mkdir -p ~/.tmux/plugins
if [ ! -d "~/.tmux/plugins/tpm" ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins
fi

tmux source ~/.tmux.conf
$HOME/.tmux/plugins/tpm/bin/install_plugins


if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

vim +PluginInstall +qall



function installZshPlugin()
{
	pluginUrl="$1"
	pluginDir="$2"

	if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/$pluginDir" ]; then
		echo "Installing ZSH plugin '$pluginDir'"
		git clone $pluginUrl ~/.oh-my-zsh/custom/plugins/$pluginDir
	else
		echo "ZSH plugin '$pluginDir' is already installed"
	fi

}


function installZshTheme()
{
	pluginUrl="$1"
	pluginDir="$2"

	if [ ! -f "$HOME/.oh-my-zsh/custom/themes/$pluginDir" ]; then
		echo "Installing ZSH theme '$pluginDir'"
		mkdir -p  ~/.oh-my-zsh/custom/themes/
		cd  ~/.oh-my-zsh/custom/themes/
		curl -fLo "$pluginDir" "$pluginUrl"
	else
		echo "ZSH theme '$pluginDir' is already installed"
	fi

}

function installFont()
{
	fontUrl="$1"
	fontName="$2"
 	mkdir -p ~/.local/share/fonts
	cd ~/.local/share/fonts

	if [ ! -f "$fontName" ]; then
		curl -fLo "$fontName" "$fontUrl"
	fi
}

function installFontsFromZip()
{
	fontUrl="$1"
	fontName="$2"
	mkdir -p ~/.local/share/fonts
	cd ~/.local/share/fonts

	if [ ! -d "$fontName" ]; then
		rm -f "/tmp/$fontName.zip"
    	curl -fLo "/tmp/$fontName.zip" "$fontUrl"
		unzip "/tmp/$fontName.zip" -d "$fontName"
	fi
}

function installGtkTheme()
{
	if [[ "$(uname -s)" == *"Linux"* ]]; then
		themeUrl="$1"
		themeName="$2"
		mkdir -p ~/.themes | true
		cd ~/.themes
		if [ ! -d "$themeName" ]; then
			rm -f "/tmp/$themeName.zip"
			curl -fLo "/tmp/$themeName.zip" "$themeUrl"
			unzip "/tmp/$themeName.zip" -d "$themeName"
		fi
	fi
}

function installPeco()
{
	if [ ! -f "/usr/local/bin/peco" ]; then
		echo "Installing Peco binary"
		url="https://github.com/peco/peco/releases/download/v0.5.1/peco_"

		platform=$(uname -s | awk '{print tolower($0)}')
		url+="$platform"
		url+="_amd64.tar.gz"
		rm -f /tmp/peco.tar.gz
		curl -fLo "/tmp/peco.tar.gz" "$url"
		cd /tmp
		tar -xzf "/tmp/peco.tar.gz" "peco_${platform}_amd64/peco"
		sudo cp "/tmp/peco_${platform}_amd64/peco" /usr/local/bin/peco
		rm -rf /tmp/peco*
	else
		echo "Peco binary already installed"
	fi
}

function getJetbrainsPluginZipUrl() {
    pluginName="$1"
    pluginBaseUrl="https://plugins.jetbrains.com/"
    requestUrl="${pluginBaseUrl}/plugin/${pluginName}"

    newUrl=$(curl "${requestUrl}" | grep -E -o '/plugin/download\?updateId=[0-9]+')

    echo "${pluginBaseUrl}${newUrl}"
}

function getJetbrainsPluginPaths() {
    productName="$1"

    echo $( find ~ -type d -name 'plugins' 2>/dev/null | grep "\.local.*${productName}")
}


function installJetbrainsPlugin() {
    set -x
    product="$1"
    zipUrl="$2"
    zipUrl=$(getJetbrainsPluginZipUrl "${zipUrl}")

    pluginDirs=$(getJetbrainsPluginPaths "${product}")

    echo "plugindirs: ${pluginDirs}"

    tmpZipFileName="/tmp/jetbrainsPlugin.zip"
    curl -L -o "${tmpZipFileName}" "${zipUrl}"
#    echo $?

    echo "after wget"
    echo "${pluginDirs[@]}"
    for pluginDir in ${pluginDirs}
    do
        echo "plugindir: ${pluginDir}"
        cd "${pluginDir}"
        unzip "${tmpZipFileName}"
    done
    set +x
}
set -e
#installJetbrainsPlugin 'IDEA-C' '1293-ruby'


installZshPlugin "git://github.com/zsh-users/zsh-autosuggestions" "zsh-autosuggestions"
installZshPlugin "https://github.com/zsh-users/zsh-completions" "zsh-completions"
installZshPlugin "https://github.com/zsh-users/zsh-syntax-highlighting.git" "zsh-syntax-highlighting"
installZshPlugin "https://github.com/jimeh/zsh-peco-history.git" "zsh-peco-history"
sed -i -e's/\s*BUFFER=.*/BUFFER=$\(fc -l -n 1 |  eval $tac | awk "\!x\[\\$0\]++" | \\/' ~/.oh-my-zsh/custom/plugins/zsh-peco-history/zsh-peco-history.zsh


installZshPlugin "https://github.com/skx/sysadmin-util.git" "sysadmin-util"

installZshTheme "https://raw.githubusercontent.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme" "bullet-train.zsh-theme"


installFont "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf" "Sauce Code Pro Nerd Font Complete.ttf"
installFont "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf" "Droid Sans Mono for Powerline Nerd Font Complete.otf"
installFont "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/AnonymousPro/complete/Anonymice%20Nerd%20Font%20Complete.ttf" "Anonymice Powerline Nerd Font Complete.ttf"
installFont "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf" "DejaVu Sans Mono Nerd Font Complete.ttf"
installFont "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf" "DejaVu Sans Mono Nerd Font Complete.ttf"

installFontsFromZip "https://github.com/RedHatBrand/Overpass/releases/download/3.0.2/overpass-desktop-fonts.zip" "overpass"
installFontsFromZip "https://github.com/supermarin/YosemiteSanFranciscoFont/archive/master.zip" "sanfrancisco"
installFontsFromZip "http://dl.1001fonts.com/alte-din-1451-mittelschrift.zip" "din-1451"

fc-cache -f -v

installGtkTheme "https://github.com/B00merang-Project/macOS-Sierra/archive/master.zip" "macOS-Sierra"

installPeco

crontab -l 2>/dev/null | grep -q "$HOME/bin/disk-usage-warning"
inCrontab=$?
if [ "${inCrontab}" == "1" ]; then
	(crontab -l 2>/dev/null; echo "*/5 * * * * export DISPLAY=:0 && $HOME/bin/disk-usage-warning 2>&1 > /dev/null") | crontab -
fi


mkdir -p $HOME/.ssh/sockets
