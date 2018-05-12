#!/usr/bin/env bash


# The unarchiver
# Wunderlist

echo "Install all AppStore Apps first!"
# no solution to automate AppStore installs
read -p "Press any key to continue... " -n1 -s
echo  '\n'

which brew
if [ $? -eq 0 ]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi



brew install hg
brew install ruby
brew install caskroom/cask/brew-cask
brew install wget
brew install midnight-commander
brew install vim
brew install grep


echo "Install Cask Core Apps"


# brew install composer
brew install htop
brew install links
# brew install python3
#brew install go
# brew install tig


brew cask install dropbox
brew cask install vlc
brew cask install google-chrome
brew cask install iterm2
brew cask install java

brew cask install phpstorm
brew cask install intellij-idea
brew cask install spotify
brew cask install virtualbox
brew cask install vagrant
brew cask install 0xdbe-eap


echo "Cleaning up Brew..."

brew cleanup --force
rm -f -r /Library/Caches/Homebrew/*