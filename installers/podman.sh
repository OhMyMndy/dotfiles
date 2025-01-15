#!/usr/bin/env bash

mkdir -p /etc/systemd/system/user@.service.d
cat >/etc/systemd/system/user@.service.d/delegate.conf <<EOF
[Service]
Delegate=cpu cpuset io memory pids
EOF
systemctl daemon-reload
touch /etc/containers/nodocker
