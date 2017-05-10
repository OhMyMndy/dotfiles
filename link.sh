#!/usr/bin/env bash

set -e

mkdir -p ~/.config

rm -f ~/.vimrc
ln -sf ~/dotfiles/.vimrc ~/.vimrc

rm -rf ~/.vim
ln -sf ~/dotfiles/.vim ~/.vim

rm -f ~/.zshrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc

rm -rf ~/.oh-my-zsh/custom
ln -sf ~/dotfiles/.oh-my-zsh/custom ~/.oh-my-zsh/custom

rm -f ~/.config/redshift.conf
ln -sf ~/dotfiles/.config/redshift.conf ~/.config/redshift.conf

ln -sfn ~/dotfiles/.config/i3 ~/.config/i3

ln -sf ~/dotfiles/.wallpaper.jpg ~/

rm -rf ~/.config/gtk-3.0
ln -sfn ~/dotfiles/.config/gtk-3.0 ~/.config/gtk-3.0

rm -f ~/.gtkrc-2.0
ln -sf ~/dotfiles/.gtkrc-2.0 ~/.gtkrc-2.0

rm -rf ~/.Xresources
ln -sf ~/dotfiles/.Xresources ~/.Xresources
touch ~/.Xresources-local

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

rm -rf ~/.themes
ln -sf ~/dotfiles/.themes ~/.themes

rm -rf ~/.icons
ln -sf ~/dotfiles/.icons ~/.icons

#sudo mkdir -p /etc/lightdm
#sudo rm -f /etc/lightdm/lightm.conf
#sudo cp ~/dotfiles/etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf


rm -f ~/.config/compton.conf
ln -sf ~/dotfiles/.config/compton.conf ~/.config/compton.conf

rm -rf ~/.config/beets
ln -sf ~/dotfiles/.config/beets ~/.config/beets

rm -f ~/.gtkrc-2.0
ln -sf ~/dotfiles/.gtkrc-2.0 ~/.gtkrc-2.0

mv -f ~/bin ~/bin_old 2>/dev/null || echo "1" > /dev/null
rm -rf ~/bin
ln -sf ~/dotfiles/bin ~/bin


rm -rf ~/.tmux
ln -sf ~/dotfiles/.tmux ~/.tmux

ln -sf ~/.byobu/.tmux.conf ~/.tmux.conf


# disable notify-osd
notify_osd_service="/usr/share/dbus-1/services/org.freedesktop.Notifications.service"
killall notify-osd > /dev/null || echo "No notify-osd running"
if [ -e "${notify_osd_service}" ]; then
	sudo mv ${notify_osd_service}{,.disabled}
fi


xrdb -merge ~/.Xresources

bash ~/.config/dunst/dunstrc.sh > ~/.config/dunst/dunstrc
bash ~/.config/terminator/config.sh > ~/.config/terminator/config


killall dunst > /dev/null || echo "No dunst found"; dunst  &
notify-send summary body
