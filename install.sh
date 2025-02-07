#!/usr/bin/env bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

if ! command -v nix &>/dev/null; then

 if [[ ! -d /run/systemd/system ]]; then
  sh <(curl -L https://nixos.org/nix/install) --no-daemon

  mkdir -p ~/.config/nix
  echo "experimental-features = nix-command flakes" >>~/.config/nix/nix.conf

  mkdir -p ~/.config/nixpkgs
  echo "{ allowUnfree = true; }" >~/.config/nixpkgs/config.nix
 else
  # Replace with lix
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux \
   --no-confirm --extra-conf "trusted-users = $USER"
 fi

fi

# if [[ "$GOOGLE_CLOUD_SHELL" == "true" ]]; then
#  mkdir -p "$HOME/nix" && sudo mkdir -p /nix && sudo mount -o bind "$HOME/nix" /nix
# fi

if command -v vim &>/dev/null && [[ -d /etc/sudoers.d ]]; then
 echo "Defaults editor=$(command -v vim)" | sudo tee /etc/sudoers.d/editor
fi

echo net.ipv4.ip_forward=1 | sudo tee /etc/sysctl.d/99-ip-forward.conf

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes.conf >/dev/null
fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 512
EOF
# Uninstalling nix
# sudo rm -rf /nix ~/.nix-*
# cat /etc/passwd | grep -E '^nix' | cut -d':' -f1 | tr '\r\n' '\0' | sudo xargs -0 -I{} userdel --remove {}
# cat /etc/group | grep -E '^nix' | cut -d':' -f1 | tr '\r\n' '\0' | sudo xargs -0 -I{} groupdel {}

if [[ -d /run/systemd/system ]]; then
 echo "Tuning nix-daemon"
 sudo systemctl set-property nix-daemon.service CPUShares=$((50 * $(nproc --all)))
 sudo systemctl set-property nix-daemon.service MemoryLimit=$(($(awk '/MemTotal/ {print $2}' /proc/meminfo) / 2 / 1024))M
 sudo systemctl daemon-reload
 sudo systemctl restart nix-daemon
fi

if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
 . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
elif [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
 . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# echo "Running home manager"
# time yes | nix run .#just -- switch

# Bridge network
# # TODO check if br0 already exists
# sudo nmcli connection add type bridge autoconnect yes ifname br0
# # TODO check if we have an ethernet device
# sudo nmcli connection add type bridge-slave autoconnect yes ifname "$(nmcli device status | awk '($2 == "ethernet") { print $1 }' | head -1)" master br0
