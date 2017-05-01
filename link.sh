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

#sudo mkdir -p /etc/lightdm
#sudo rm -f /etc/lightdm/lightm.conf
#sudo cp ~/dotfiles/etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf


rm -f ~/.config/compton.conf
ln -sf ~/dotfiles/.config/compton.conf ~/.config/compton.conf

rm -rf ~/.config/beets
ln -sf ~/dotfiles/.config/beets ~/.config/beets
