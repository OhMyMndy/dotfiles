#!/usr/bin/env bash

dark_mode=$(cat $HOME/.dark-mode 2>/dev/null)
echo "dark mode: $dark_mode"
#set -e

mkdir -p ~/.config

rm -f ~/.vimrc
ln -sf ~/dotfiles/.vimrc ~/.vimrc

rm -f ~/.dircolors
ln -sf ~/dotfiles/.dircolors ~/.dircolors

rm -rf ~/.vim
ln -sf ~/dotfiles/.vim ~/.vim

rm -f ~/.zshrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc


ln -sf ~/dotfiles/.oh-my-zsh/custom/themes/mandy.zsh ~/.oh-my-zsh/custom/themes/mandy.zsh

rm -f ~/.config/redshift.conf
ln -sf ~/dotfiles/.config/redshift.conf ~/.config/redshift.conf

ln -sfn ~/dotfiles/.config/i3 ~/.config/i3

ln -sf ~/dotfiles/.wallpaper.jpg ~/.wallpaper.jpg

rm -rf ~/.config/gtk-3.0
ln -sfn ~/dotfiles/.config/gtk-3.0 ~/.config/gtk-3.0


rm -rf ~/.conkyrc
ln -sf ~/dotfiles/.conkyrc ~/.conkyrc

rm -f ~/.screenrc
ln -sf ~/dotfiles/.screenrc ~/.screenrc

rm -rf ~/.config/terminator
ln -sf ~/dotfiles/.config/terminator ~/.config/terminator

rm -rf ~/.config/polybar
ln -sf ~/dotfiles/.config/polybar ~/.config/polybar

rm -rf ~/.byobu
ln -sf ~/dotfiles/.byobu ~/.byobu

rm -rf ~/.config/fontconfig
ln -sf ~/dotfiles/.config/fontconfig ~/.config/fontconfig

rm -f ~/.yaourtrc
ln -sf ~/dotfiles/.yaourtrc ~/.yaourtrc

rm -rf ~/.config/mopidy
ln -sf ~/dotfiles/.config/mopidy ~/.config/mopidy

rm -rf ~/.config/htop
ln -sf ~/dotfiles/.config/htop ~/.config/htop

rm -rf ~/.screenlayout
ln -sf ~/dotfiles/.screenlayout ~/.screenlayout

rm -rf ~/.config/sublime-text-2
ln -sf ~/dotfiles/.config/sublime-text-2 ~/.config/sublime-text-2

rm -f ~/z.sh
ln -sf ~/dotfiles/z.sh ~/z.sh

rm -f ~/.xinitrc
ln -sf ~/dotfiles/.xinitrc ~/.xinitrc

touch ~/.z


rm -rf ~/.icons
ln -sf ~/dotfiles/.icons ~/.icons

#sudo mkdir -p /etc/lightdm
#sudo rm -f /etc/lightdm/lightm.conf
#sudo cp ~/dotfiles/etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf


rm -f ~/.config/compton.conf
ln -sf ~/dotfiles/.config/compton.conf ~/.config/compton.conf

rm -rf ~/.config/beets
ln -sf ~/dotfiles/.config/beets ~/.config/beets

rm -rf ~/.config/ranger
ln -sf ~/dotfiles/.config/ranger ~/.config/ranger

mv -f ~/bin ~/bin_old 2>/dev/null || echo "1" > /dev/null
rm -rf ~/bin
ln -sf ~/dotfiles/bin ~/bin
chmod +x -R ~/bin/


rm -rf ~/.tmux
ln -sf ~/dotfiles/.tmux ~/.tmux

ln -sf ~/.byobu/.tmux.conf ~/.tmux.conf

rm -f ~/.apm-packages
ln -sf ~/dotfiles/.apm-packages ~/.apm-packages

rm -f ~/.imwheelrc
ln -sf ~/dotfiles/.imwheelrc ~/.imwheelrc

rm -f ~/.inputrc
ln -sf ~/dotfiles/.inputrc ~/.inputrc

ln -sf ~/dotfiles/functions.sh ~/functions.sh

rm -rf ~/.config/peco
ln -sf ~/dotfiles/.config/peco ~/.config/peco

rm -f ~/.fonts.conf
ln -sf ~/dotfiles/.fonts.conf ~/.fonts.conf


if [ "$dark_mode" = "1" ]; then
	sed -E -i 's/one-light/one-dark/g' ~/.atom/config.cson > /dev/null 2>&1
else
	sed -E -i 's/one-dark/one-light/g' ~/.atom/config.cson > /dev/null 2>&1
fi

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
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
installJetbrainsPlugin 'IDEA-C' '1293-ruby'


exit 2


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
