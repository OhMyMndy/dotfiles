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

rm -rf ~/.oh-my-zsh/custom/themes
ln -sf ~/dotfiles/.oh-my-zsh/custom/themes ~/.oh-my-zsh/custom/themes

rm -f ~/.config/redshift.conf
ln -sf ~/dotfiles/.config/redshift.conf ~/.config/redshift.conf

ln -sfn ~/dotfiles/.config/i3 ~/.config/i3

ln -sf ~/dotfiles/.wallpaper.jpg ~/.wallpaper.jpg

rm -rf ~/.config/gtk-3.0
ln -sfn ~/dotfiles/.config/gtk-3.0 ~/.config/gtk-3.0

rm -f ~/.gtkrc-2.0
ln -sf ~/dotfiles/.gtkrc-2.0 ~/.gtkrc-2.0

rm -rf ~/.conkyrc
ln -sf ~/dotfiles/.conkyrc ~/.conkyrc

rm -f ~/.screenrc
ln -sf ~/dotfiles/.screenrc ~/.screenrc

rm -rf  ~/.config/dunst
ln -sf ~/dotfiles/.config/dunst ~/.config/dunst

rm -rf ~/.config/rofi
ln -sf ~/dotfiles/.config/rofi ~/.config/rofi

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

rm -f ~/.gtkrc-2.0
ln -sf ~/dotfiles/.gtkrc-2.0 ~/.gtkrc-2.0

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




if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
	git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]; then
	git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

set -ex
if [ ! -f "$HOME/.oh-my-zsh/custom/themes/bullet-train.zsh-theme" ]; then
    curl https://raw.githubusercontent.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme -o ~/.oh-my-zsh/custom/themes/bullet-train.zsh-theme
fi


if [ ! -f "$HOME/.local/share/fonts/Sauce Code Pro Nerd Font Complete.ttf" ]; then
    mkdir -p ~/.local/share/fonts; cd ~/.local/share/fonts 
    curl -fLo "Sauce Code Pro Nerd Font Complete.ttf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf
	fc-cache -f -v
fi

if [ ! -f "$HOME/.local/share/fonts/Droid Sans Mono for Powerline Nerd Font Complete.otf" ]; then
    mkdir -p ~/.local/share/fonts; cd ~/.local/share/fonts 
    curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
	fc-cache -f -v
fi

if [ ! -f "$HOME/.local/share/fonts/Anonymice Powerline Nerd Font Complete.ttf" ]; then
    mkdir -p ~/.local/share/fonts; cd ~/.local/share/fonts 
    curl -fLo "Anonymice Powerline Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/AnonymousPro/complete/Anonymice%20Nerd%20Font%20Complete.ttf
	fc-cache -f -v
fi

if [ ! -f "$HOME/.local/share/fonts/DejaVu Sans Mono Nerd Font Complete.ttf" ]; then
    mkdir -p ~/.local/share/fonts; cd ~/.local/share/fonts 
    curl -fLo "DejaVu Sans Mono Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf
	fc-cache -f -v
fi

if [ ! -d "$HOME/.local/share/fonts/overpass" ]; then
    mkdir -p ~/.local/share/fonts; cd ~/.local/share/fonts 
    curl -fLo "/tmp/overpass.zip" https://github.com/RedHatBrand/Overpass/releases/download/3.0.2/overpass-desktop-fonts.zip
	unzip /tmp/overpass.zip
	fc-cache -f -v
fi

if [ ! -d "$HOME/.local/share/fonts/YosemiteSanFranciscoFont-master" ]; then
    mkdir -p ~/.local/share/fonts/; 
	cd ~/.local/share/fonts/
    curl -fLo "/tmp/sanfrancisco.zip" https://github.com/supermarin/YosemiteSanFranciscoFont/archive/master.zip
	unzip /tmp/sanfrancisco.zip
	fc-cache -f -v
fi

if [ ! -d "$HOME/.themes/macOS-Sierra-master" ]; then
    mkdir -p ~/.themes | true
	cd ~/.themes
    wget https://github.com/B00merang-Project/macOS-Sierra/archive/master.zip
    unzip *master.zip
fi


crontab -l 2>/dev/null | grep -q "$HOME/bin/disk-usage-warning"
inCrontab=$?
if [ "${inCrontab}" == "1" ]; then
	(crontab -l 2>/dev/null; echo "*/5 * * * * export DISPLAY=:0 && $HOME/bin/disk-usage-warning 2>&1 > /dev/null") | crontab -
fi


mkdir -p $HOME/.ssh/sockets