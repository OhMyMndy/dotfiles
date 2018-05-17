#!/usr/bin/env bash

# dependencies: autoconf automake
cd /tmp
git clone https://github.com/lolilolicon/xrectsel.git
cd xrectsel

./bootstrap
./configure --prefix /usr
make
sudo make install
