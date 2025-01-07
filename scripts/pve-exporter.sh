#!/usr/bin/env bash

apt-get install pipx -y

useradd -m prometheus

sudo -u prometheus bash -c "pipx install prometheus-pve-exporter"

mkdir -p /etc/prometheus
cat <<EOF >/etc/prometheus/pve.yml
default:
    user: prometheus@pve
    password: sEcr3T!
    verify_ssl: false
EOF

cat <<EOF >/etc/systemd/system/prometheus-pve-exporter.service
[Unit]
Description=Prometheus exporter for Proxmox VE
Documentation=https://github.com/znerol/prometheus-pve-exporter

[Service]
Restart=always
User=prometheus
ExecStart=/home/prometheus/.local/pipx/venvs/prometheus-pve-exporter/bin/pve_exporter --config.file /etc/prometheus/pve.yml

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl restart prometheus-pve-exporter
