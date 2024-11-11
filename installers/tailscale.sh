#!/usr/bin/env tailscale

if ! command -v tailscale &>/dev/null; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi

echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf


# TODO remove when https://github.com/tailscale/tailscale/issues/1227 gets fixed
cat <<EOL | sudo tee /etc/systemd/system/fix-tailscale-lan-access.service
[Unit]
Description=Fix Tailscale LAN Access Route
After=tailscaled.service
Requires=tailscaled.service

[Service]
Type=oneshot
ExecStart=/bin/bash -c "for i in {1..4}; do /usr/sbin/ip route del 10.0.40.0/23 dev tailscale0 table 52 && exit 0; sleep 2; done; exit 1"

[Install]
WantedBy=tailscaled.service
EOL

# Reload systemd to pick up the new service
sudo systemctl daemon-reload

# Enable the new service to run after tailscaled.service starts/restarts
sudo systemctl enable fix-tailscale-lan-access.service

# Restart tailscaled.service to trigger the fix service
sudo systemctl restart tailscaled.service
