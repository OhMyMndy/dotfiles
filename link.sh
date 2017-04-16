#!/usr/bin/env bash

set -e

ln -sf ~/dotfiles/.vimrc ~/.vimrc

ln -sf ~/dotfiles/.zshrc ~/.zshrc

ln -sf ~/dotfiles/.config/redshift.conf ~/.config/redshift.conf

ln -sfn ~/dotfiles/.config/i3 ~/.config/

ln -sf ~/dotfiles/.wallpaper.jpg ~/

rm -rf ~/.config/gtk-3.0
ln -sfn ~/dotfiles/.config/gtk-3.0 ~/.config/

rm -f ~/.gtkrc-2.0
ln -sf ~/dotfiles/.gtkrc-2.0 ~/

rm -rf ~/.Xresources
ln -sf ~/dotfiles/.Xresources ~/

rm -rf ~/.conkyrc
ln -sf ~/dotfiles/.conkyrc ~/.conkyrc

rm -f ~/.screenrc
ln -sf ~/dotfiles/.screenrc ~/

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
ln -sf ~/dotfiles/.yaourtrc ~/
