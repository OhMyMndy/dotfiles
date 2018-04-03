#!/usr/bin/env bash

cd /tmp || exit 1
rm -f apache-jmeter-4.0.tgz
curl http://apache.redkiwi.nl//jmeter/binaries/apache-jmeter-4.0.tgz -o apache-jmeter-4.0.tgz
tar xzf apache-jmeter-4.0.tgz
sudo mv /tmp/apache-jmeter-4.0 /opt/
sudo ln -s /opt/apache-jmeter-4.0/bin/jmeter /usr/bin/jmeter


curl -L -O -J https://jmeter-plugins.org/get/
sudo mv jmeter-plugins-manager* /opt/apache-jmeter-4.0/lib/ext/
