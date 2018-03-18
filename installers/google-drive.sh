#!/usr/bin/env bash

# initialize access token
google-drive-ocamlfuse


sudo mkdir -p /mnt/gdrive
sudo chown mandy:mandy -R /mnt/gdrive

google-drive-ocamlfuse mountpoint /mnt/gdrive
