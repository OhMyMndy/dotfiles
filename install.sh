#!/usr/bin/env bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

if ! command -v nix &>/dev/null; then
 # Replace with lix
 curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm --extra-conf "trusted-users = $USER"

 if [[ ! -d /run/systemd/system ]]; then
  sudo chown -R $USER:$USER /nix
 fi

fi

# Uninstalling nix
# sudo rm -rf /nix ~/.nix-*
# cat /etc/passwd | grep -E '^nix' | cut -d':' -f1 | tr '\r\n' '\0' | sudo xargs -0 -I{} userdel --remove {}
# cat /etc/group | grep -E '^nix' | cut -d':' -f1 | tr '\r\n' '\0' | sudo xargs -0 -I{} groupdel {}

if [[ -d /run/systemd/system ]]; then
 sudo systemctl set-property nix-daemon.service CPUShares=$((50 * $(nproc --all)))
 sudo systemctl set-property nix-daemon.service MemoryLimit=$(($(awk '/MemTotal/ {print $2}' /proc/meminfo) / 2 / 1024))M
 sudo systemctl daemon-reload
 sudo systemctl restart nix-daemon
fi

if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
 . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

time yes | nix run .#just -- switch
