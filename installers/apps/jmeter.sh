#!/usr/bin/env bash

#shellcheck disable=SC2230

trap "exit" INT


cd /tmp || exit 1
rm -f apache-jmeter-5.2.1.tgz
curl http://apache.redkiwi.nl//jmeter/binaries/apache-jmeter-5.2.1.tgz -o apache-jmeter-5.2.1.tgz
tar xzf apache-jmeter-5.2.1.tgz
sudo mv /tmp/apache-jmeter-5.2.1 /opt/
sudo ln -s /opt/apache-jmeter-5.2.1/bin/jmeter /usr/bin/jmeter


curl -L -O -J https://jmeter-plugins.org/get/
sudo mv jmeter-plugins-manager* /opt/apache-jmeter-5.2.1/lib/ext/

if which apt &>/dev/null; then
	sudo apt install openjdk-11-jre -y
fi
