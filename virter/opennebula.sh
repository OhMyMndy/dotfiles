#!/usr/bin/env bash

set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

if ! virter image ls | grep -q alma-9; then
  virter image pull alma-9
fi
virter vm run alma-9 --bootcapacity 22GiB --memory 4GiB \
  --vcpus 2 --name opennebula-cluster --id 11 --count 4 \
  --provision "$DIR/opennebula.toml" || true

cd /tmp

if [[ ! -d one-deploy ]]; then
  git clone https://github.com/OpenNebula/one-deploy.git
fi

cd one-deploy

ansible -i "$DIR/opennebula/hosts.yml" all -m ping -b

ansible-playbook -v opennebula.deploy.main -i "$DIR/opennebula/hosts.yml"
