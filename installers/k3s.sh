#!/usr/bin/env bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.30.8+k3s1 sh -s - --disable=servicelb --disable=traefik --disable-network-policy --flannel-backend=none --write-kubeconfig-mode 644

KUBECONFIG=/etc/rancher/k3s/k3s.yaml

export KUBECONFIG
helmfile -f ../k3s/helmfile.yaml sync
