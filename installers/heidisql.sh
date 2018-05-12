#!/usr/bin/env bash

cd /tmp || exit 1
rm -f HeidiSQL_9.5_Portable.zip
curl https://www.heidisql.com/downloads/releases/HeidiSQL_9.5_Portable.zip -o HeidiSQL_9.5_Portable.zip
rm -rf heidisql
mkdir heidisql && cd heidisql || exit 2
unzip /tmp/HeidiSQL_9.5_Portable.zip
sudo mv /tmp/heidisql /opt/
