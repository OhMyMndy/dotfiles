#!/usr/bin/env bash

rm -rf /tmp/purevpn-1.0.0-1.amd64.rpm
curl -L https://s3.amazonaws.com/purevpn-dialer-assets/linux/app/purevpn-1.0.0-1.amd64.rpm > /tmp/purevpn-1.0.0-1.amd64.rpm
sudo dnf install -y /tmp/purevpn-1.0.0-1.amd64.rpm

# Old installer below
exit 4

rm /tmp/linux-files.zip
rm -rf /tmp/linux-files
mkdir -p /tmp/linux-files
curl -L https://s3-us-west-1.amazonaws.com/heartbleed/linux/linux-files.zip > /tmp/linux-files.zip

cd /tmp/linux-files || exit 1
unzip /tmp/linux-files.zip

cd Linux\ OpenVPN\ Updated\ files || exit 2

sudo chmod 777  /etc/openvpn/
sudo cp ca.crt TCP/* UDP/* Wdc.key /etc/openvpn/

sudo chmod 774 -R /etc/openvpn/
sudo chmod 700 -R /etc/openvpn/*.key


rm /tmp/linux-files.zip
rm -rf /tmp/linux-files
