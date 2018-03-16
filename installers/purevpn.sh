#!/usr/bin/env bash

rm /tmp/linux-files.zip
rm -rf /tmp/linux-files
mkdir -p /tmp/linux-files
curl -L https://s3-us-west-1.amazonaws.com/heartbleed/linux/linux-files.zip > /tmp/linux-files.zip

cd /tmp/linux-files
unzip /tmp/linux-files.zip

cd Linux\ OpenVPN\ Updated\ files

sudo chmod 777  /etc/openvpn/
sudo cp ca.crt TCP/* UDP/* Wdc.key /etc/openvpn/

sudo chmod 774 -R /etc/openvpn/
sudo chmod 700 -R /etc/openvpn/*.key


rm /tmp/linux-files.zip
rm -rf /tmp/linux-files
