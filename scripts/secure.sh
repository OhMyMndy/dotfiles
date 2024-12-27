#!/usr/bin/env bash

# Increase security based on Lynis findings
#
sudo systemctl mask cupsd

# TODO: get correct network device
sudo ip link set ens18 promisc off

cat <<EOL | sudo tee /etc/security/limits.d/99-disable-core-dumps.conf
* hard core 0
* soft core 0
EOL

# cat <<EOL | sudo tee /etc/sysctl.d/9999-disable-core-dump.conf
# fs.suid_dumpable=0
# kernel.core_pattern=|/bin/false
# EOL

# sudo sysctl -p /etc/sysctl.d/9999-disable-core-dump.conf
