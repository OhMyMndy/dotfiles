#!/usr/bin/env bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

cat <<EOF | sudo tee /etc/wsl.conf >/dev/null
[boot]
systemd=true
[network]
generateResolvConf = false
EOF

sudo mkdir -p /etc/systemd/resolved.conf.d
cat <<EOF | sudo tee /etc/systemd/resolved.conf.d/1-wsl.conf >/dev/null
[Resolve]
DNS=1.1.1.1
FallbackDNS=9.9.9.9
EOF

sudo systemctl restart systemd-resolved
