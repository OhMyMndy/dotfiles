#!/usr/bin/env bash

install_appimage () {
  url="$1"
  filename="$2"
  if [ ! -f /usr/local/bin/$filename ]; then
    rm /tmp/$filename 2>/dev/null
    curl -L $url > /tmp/$filename
    rm /usr/local/bin/$filename 2>/dev/null
    sudo mv "/tmp/$filename" /usr/local/bin/$filename

    chmod a+x /usr/local/bin/$filename
  fi
}

install_appimage https://github.com/AppImage/AppImageUpdate/releases/download/continuous/AppImageUpdate-222-acb9d03-x86_64.AppImage AppImageUpdate
install_appimage https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage AppImageTool
install_appimage https://github.com/saenzramiro/rambox/releases/download/0.5.14/Rambox-0.5.14-ia32.AppImage rambox
install_appimage https://github.com/oguzhaninan/Stacer/releases/download/v1.0.8/Stacer_x64_v1.0.8.AppImage stacer

# Jetbrains toolbox
if [ ! -f /usr/local/bin/jetbrains-toolbox ]; then
  sudo rm /usr/local/bin/jetbrains-toolbox 2>/dev/null
  curl -L https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.6.2914.tar.gz > /tmp/jetbrains-toolbox
  cd /usr/local/bin/
  sudo tar -xvzf /tmp/jetbrains-toolbox jetbrains-toolbox-1.6.2914/jetbrains-toolbox --strip=1
  rm /tmp/jetbrains-toolbox
fi

# AppImageD
if [ ! -f ~/.local/bin/appimaged ]; then
  install_appimage https://github.com/AppImage/AppImageKit/releases/download/continuous/appimaged-x86_64.AppImage AppImageD
  sudo AppImageD --install
fi
