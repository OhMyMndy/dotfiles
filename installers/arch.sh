#!/usr/bin/env bash


if ! grep  'archlinuxfr' /etc/pacman.conf ; then
   cat <<'EOL' | sudo tee -a /etc/pacman.conf

[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
EOL
fi

sudo pacman -Syu yaourt
yaourt -Syu


cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete.otf


yaourt -S i3-gaps
yaourt -S polybar
yaourt -S rofi
yaourt -S zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

yaourt -S ttf-chromeos-fonts
yaourt -S nerd-fonts-source-code-pro
yaourt -S parcellite
yaourt -S redshift
yaourt -S chromium
yaourt -S lightdm
yaourt -S autokey-py3
