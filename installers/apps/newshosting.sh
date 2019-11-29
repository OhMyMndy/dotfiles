#!/usr/bin/env bash

trap "exit" INT

rm -f /tmp/newshosting.run
curl -L http://client-index.newshosting.com/nh/2.8.10/linux/newshosting-2.8.10-linux-x64-installer.run > /tmp/newshosting.run

chmod +x /tmp/newshosting.run
/tmp/newshosting.run --mode unattended --prefix "$HOME/newshosting"
rm -f /tmp/newshosting.run

