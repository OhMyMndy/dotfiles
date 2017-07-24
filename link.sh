#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dark_mode=$(cat $HOME/.dark-mode 2>/dev/null)
echo "dark mode: $dark_mode"
#set -e

mkdir -p ~/.config

rm -f ~/.vimrc
ln -sf $DIR/.vimrc ~/.vimrc

rm -f ~/.dircolors
ln -sf ~/dotfiles/.dircolors ~/.dircolors

rm -rf ~/.vim
ln -sf $DIR/.vim ~/.vim

rm -f ~/.zshrc
ln -sf $DIR/.zshrc ~/.zshrc

rm -rf ~/.oh-my-zsh/custom
ln -sf $DIR/.oh-my-zsh/custom ~/.oh-my-zsh/custom

rm -f ~/.config/redshift.conf
ln -sf $DIR/.config/redshift.conf ~/.config/redshift.conf

rm -rf ~/.config/i3
ln -sfn $DIR/.config/i3 ~/.config/i3

ln -sf $DIR/.wallpaper.jpg ~/.wallpaper.jpg

rm -rf ~/.config/gtk-3.0
ln -sfn $DIR/.config/gtk-3.0 ~/.config/gtk-3.0

rm -f ~/.gtkrc-2.0
ln -sf $DIR/.gtkrc-2.0 ~/.gtkrc-2.0

rm -rf ~/.conkyrc
ln -sf $DIR/.conkyrc ~/.conkyrc

rm -f ~/.screenrc
ln -sf $DIR/.screenrc ~/.screenrc

rm -rf  ~/.config/dunst
ln -sf $DIR/.config/dunst ~/.config/dunst

rm -rf ~/.config/rofi
ln -sf $DIR/.config/rofi ~/.config/rofi

rm -rf ~/.config/terminator
ln -sf $DIR/.config/terminator ~/.config/terminator

rm -rf ~/.config/polybar
ln -sf $DIR/.config/polybar ~/.config/polybar

rm -rf ~/.byobu
ln -sf $DIR/.byobu ~/.byobu

rm -rf ~/.config/fontconfig
ln -sf $DIR/.config/fontconfig ~/.config/fontconfig

rm -f ~/.yaourtrc
ln -sf $DIR/.yaourtrc ~/.yaourtrc

rm -rf ~/.config/mopidy
ln -sf $DIR/.config/mopidy ~/.config/mopidy

rm -rf ~/.config/htop
ln -sf $DIR/.config/htop ~/.config/htop

rm -rf ~/.screenlayout
ln -sf $DIR/.screenlayout ~/.screenlayout

rm -rf ~/.config/sublime-text-2
ln -sf $DIR/.config/sublime-text-2 ~/.config/sublime-text-2

rm -f ~/z.sh
ln -sf $DIR/z.sh ~/z.sh

rm -f ~/.xinitrc
ln -sf $DIR/.xinitrc ~/.xinitrc

touch ~/.z

rm -rf ~/.themes
ln -sf $DIR/.themes ~/.themes

rm -rf ~/.icons
ln -sf $DIR/.icons ~/.icons

#sudo mkdir -p /etc/lightdm
#sudo rm -f /etc/lightdm/lightm.conf
#sudo cp $DIR/etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf


rm -f ~/.config/compton.conf
ln -sf $DIR/.config/compton.conf ~/.config/compton.conf

rm -rf ~/.config/beets
ln -sf $DIR/.config/beets ~/.config/beets

rm -f ~/.gtkrc-2.0
ln -sf $DIR/.gtkrc-2.0 ~/.gtkrc-2.0

mv -f ~/bin ~/bin_old 2>/dev/null || echo "1" > /dev/null
rm -rf ~/bin
ln -sf $DIR/bin ~/bin


rm -rf ~/.tmux
ln -sf $DIR/.tmux ~/.tmux

ln -sf ~/.byobu/.tmux.conf ~/.tmux.conf

rm -f ~/.apm-packages
ln -sf $DIR/.apm-packages ~/.apm-packages

rm -f ~/.imwheelrc
ln -sf $DIR/.imwheelrc ~/.imwheelrc

rm -f ~/.inputrc
ln -sf $DIR/.inputrc ~/.inputrc

# disable notify-osd
notify_osd_service="/usr/share/dbus-1/services/org.freedesktop.Notifications.service"
killall notify-osd > /dev/null || true
if [ -e "${notify_osd_service}" ]; then
	sudo mv ${notify_osd_service}{,.disabled} || true
fi

rm -rf ~/.Xresources
touch ~/.Xresources-local

bash $DIR/.Xresources.sh > ~/.Xresources

xrdb -remove
xrdb -override ~/.Xresources


bash ~/.config/dunst/dunstrc.sh > ~/.config/dunst/dunstrc
bash ~/.config/terminator/config.sh > ~/.config/terminator/config

if [ "$dark_mode" = "1" ] && [ -f "~/.atom/config.cson" ]; then
	sed -E -i 's/one-light/one-dark/g' ~/.atom/config.cson > /dev/null
elif [ -f "~/.atom/config.cson" ]; then
	sed -E -i 's/one-dark/one-light/g' ~/.atom/config.cson > /dev/null
fi

killall dunst > /dev/null || echo "No dunst found";
dunst  > /dev/null 2>&1 || true &
notify-send summary body || true

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins
fi

tmux source ~/.tmux.conf || true
$HOME/.tmux/plugins/tpm/bin/install_plugins || true
echo 3

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
    curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete.otf
	fc-cache -f -v
fi

if [ ! -f "$HOME/.local/share/fonts/Anonymice Powerline Nerd Font Complete.ttf" ]; then
    mkdir -p ~/.local/share/fonts; cd ~/.local/share/fonts
    curl -fLo "Anonymice Powerline Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/AnonymousPro/complete/Anonymice%20Powerline%20Nerd%20Font%20Complete.ttf?raw=true
	fc-cache -f -v
fi

if [ ! -f "$HOME/.local/share/fonts/DejaVu Sans Mono Nerd Font Complete.ttf" ]; then
    mkdir -p ~/.local/share/fonts; cd ~/.local/share/fonts
    curl -fLo "DejaVu Sans Mono Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf?raw=true
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

# if [ ! -d "$HOME/.local/share/fonts/fonts-master" ]; then
#     mkdir -p ~/.local/share/fonts/;
# 	cd ~/.local/share/fonts/
#     curl -fLo "/tmp/google-fonts.zip" https://github.com/google/fonts/archive/master.zip
# 	unzip /tmp/google-fonts.zip
# 	fc-cache -f -v
# fi

