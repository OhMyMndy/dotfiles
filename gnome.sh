#!/usr/bin/env bash

set -e
sudo apt-get update -y -qq
sudo apt-get install git node-typescript make -y -qq

mkdir -p ~/src && cd ~/src
git clone https://github.com/pop-os/shell.git pop-os-shell | true
cd ~/src/pop-os-shell
git pull

yes | make local-install
