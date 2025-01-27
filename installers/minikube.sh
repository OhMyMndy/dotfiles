#!/usr/bin/env bash

# minikube start --driver=kvm2 --memory=4000m --nodes=3 --kubernetes-version=v1.30.9
# minikube addons enable ingress
# minikube addons enable ingress-dns
# minikube addons enable metrics-server
#
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

if command -v dnf &>/dev/null && ! command -v firewall-cmd &>/dev/null; then
  sudo dnf install firewalld -y
  sudo systemctl enable --now firewalld
fi

if ! command -v minikube &>/dev/null; then
  echo "Minikube not found!" 2>&1
  exit 3
fi

if systemctl is-active systemd-resolved.service &>/dev/null; then
  sudo mkdir -p /etc/systemd/resolved.conf.d
  sudo tee /etc/systemd/resolved.conf.d/minikube.conf <<EOF
[Resolve]
DNS=$(minikube ip)
Domains=~test
EOF
  sudo systemctl restart systemd-resolved
fi
