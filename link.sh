#!/usr/bin/env bash

set -e

ln -sf ~/dotfiles/.vimrc ~/.vimrc

ln -sf ~/dotfiles/.zshrc ~/.zshrc

ln -sf ~/dotfiles/.config/redshift.conf ~/.config/redshift.conf

ln -sfn ~/dotfiles/.config/i3 ~/.config/

ln -sf ~/dotfiles/.wallpaper.jpg ~/

rm -rf ~/.config/gtk-3.0
ln -sfn ~/dotfiles/.config/gtk-3.0 ~/.config/

rm -rf ~/.Xresources
ln -sf ~/dotfiles/.Xresources 
