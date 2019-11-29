#!/usr/bin/env bash

trap "exit" INT


curl https://atomicamps.com/wp-content/uploads/2018/11/AmplifireEditor_6_1_1_1_Win.zip > ~/bin/AmplifireEditor.zip

cd ~/bin || exit

rm AmplifireEditor.exe
unzip AmplifireEditor.zip
rm AmplifireEditor.zip


echo 'SUBSYSTEMS=="usb", ATTRS{manufacturer}=="Atomic Amps", MODE="0666"' | sudo tee /etc/udev/rules.d/11-amplifire.rules
sudo systemctl restart udev