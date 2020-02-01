#!/usr/bin/env bash

cd /tmp || exit 1

# Needs libXt-devel, libXi-devel, libXfixes-devel  on Fedora

git clone -q https://github.com/jcs/xbanish.git
cd xbanish || exit 2
make install
