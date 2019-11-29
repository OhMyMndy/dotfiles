#!/usr/bin/env bash

# shellcheck disable=SC2230

trap "exit" INT


# The unarchiver
# Wunderlist

echo "Install all AppStore Apps first!"
# no solution to automate AppStore installs
read -r -p "Press any key to continue... " -n1 -s
echo

if command -v brew &>/dev/null; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi



brew install hg
brew install ruby
brew install caskroom/cask/brew-cask
brew install wget
brew install vim
brew install coreutils



echo "Install Cask Core Apps"


# brew install composer
brew install htop
brew install links
brew install wget
# brew install python3
#brew install go
# brew install tig


brew cask install vlc
brew cask install keka
brew cask install google-chrome
brew cask install iterm2
brew cask install cleanmymac
brew cask install spectacle
brew cask install 1password

brew cask install phpstorm
brew cask install virtualbox

brew cask install disk-inventory-x


echo "Cleaning up Brew..."

brew cleanup --force
rm -f -r /Library/Caches/Homebrew/*
