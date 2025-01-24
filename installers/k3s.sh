#!/usr/bin/env bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

if command -v dnf &>/dev/null && ! command -v firewall-cmd &>/dev/null; then
  sudo dnf install firewalld -y
  sudo systemctl enable --now firewalld
fi

if command -v dnf &>/dev/null && [[ ! -d /usr/share/bash_completion ]]; then
  sudo dnf install bash-completion -y
fi

if [[ ! -f /etc/rancher/k3s/k3s.yaml ]]; then
  sudo mkdir -p /etc/rancher/k3s
  echo "nameserver 9.9.9.9" | sudo tee /etc/rancher/k3s/custom-resolv.conf >/dev/null
  sudo mkdir -p /var/lib/rancher/k3s/server/manifests/
  sudo cp ../k3s/manifests/traefik-override.yaml /var/lib/rancher/k3s/server/manifests/traefik-override.yaml

  curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.30.8+k3s1 sh -s - \
    --write-kubeconfig-mode 644 \
    --resolv-conf=/etc/rancher/k3s/custom-resolv.conf
  #--disable=traefik
  # ---flannel-backend=none  ---disable-network-policy -disable=servicelb \--disable-kube-proxy
fi

KUBECONFIG=/etc/rancher/k3s/k3s.yaml

sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
export KUBECONFIG

IP_ADDRESS="$(ip route | awk '($1 == "default") {print $9}')"
export IP_ADDRESS

helmfile -f ../k3s/helmfile.yaml sync --color
