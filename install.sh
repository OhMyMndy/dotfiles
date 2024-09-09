#!/usr/bin/env bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

if ! command -v nix &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm --extra-conf "trusted-users = $USER"
fi


## START FLOX
CONF_FILE="/etc/nix/nix.conf"
SUBSTITUTERS="extra-trusted-substituters = https://cache.flox.dev"
PUBLIC_KEYS="extra-trusted-public-keys = flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="

# Check if substituters are already in the config file
if ! grep -Fxq "$SUBSTITUTERS" "$CONF_FILE"; then
    echo "$SUBSTITUTERS" | sudo tee -a "$CONF_FILE" > /dev/null
fi

# Check if public keys are already in the config file
if ! grep -Fxq "$PUBLIC_KEYS" "$CONF_FILE"; then
    echo "$PUBLIC_KEYS" | sudo tee -a "$CONF_FILE" > /dev/null
fi
## END FLOX

time nix run .#just -- switch
