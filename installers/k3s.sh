#!/usr/bin/env bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

if [[ ! -f /etc/rancher/k3s/k3s.yaml ]]; then
  curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.30.8+k3s1 sh -s - \
    --disable-network-policy --flannel-backend=none --write-kubeconfig-mode 644
  # --disable=servicelb --disable=traefik \
fi

sudo cp ../k3s/manifests/traefik-override.yaml /var/lib/rancher/k3s/server/manifests/traefik-override.yaml
KUBECONFIG=/etc/rancher/k3s/k3s.yaml

sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
export KUBECONFIG

IP_ADDRESS="$(ip route | awk '($1 == "default") {print $9}')"
export IP_ADDRESS
set -x
helmfile -f ../k3s/helmfile.yaml sync --skip-refresh --color
