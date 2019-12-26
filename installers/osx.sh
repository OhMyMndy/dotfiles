#!/usr/bin/env bash

# shellcheck disable=SC2230

trap "exit" INT


# The unarchiver
# Wunderlist

trap "exit" INT


which brew &>/dev/null
if [ $? -ne 0 ]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew install hg
brew install ruby
brew tap caskroom/cask
brew install wget
brew install vim
brew install coreutils


# brew install composer
brew install htop
#brew install links
brew install wget
brew install curl
# brew install python3
#brew install go
# brew install tig


brew cask install vlc
brew cask install keka
brew cask install google-chrome
brew cask install iterm2
#brew cask install cleanmymac
brew cask install spectacle
brew cask install 1password

brew cask install xquartz
brew cask install caffeine
brew cask install nextcloud
brew cask install flux

brew cask install phpstorm
#brew cask install virtualbox

brew cask install disk-inventory-x

brew cask install android-platform-tools
brew install zenity
brew install bash

brew cask install copyq

brew install docker
brew install sshfs
brew install scrcpy

brew upgrade
brew cleanup 
rm -f -r /Library/Caches/Homebrew/*
