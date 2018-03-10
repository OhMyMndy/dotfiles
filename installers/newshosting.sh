#!/usr/bin/env bash
rm -f /tmp/newshosting.run
curl http://ams-cdn.aboutusenet.com/nh/2.6.3/linux/newshosting-2.6.3-linux-x64-installer.run > /tmp/newshosting.run

chmod +x /tmp/newshosting.run
/tmp/newshosting.run --mode unattended --prefix $HOME/newshosting
rm -f /tmp/newshosting.run
