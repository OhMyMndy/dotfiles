# shellcheck shell=bash

if [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]; then
    # shellcheck disable=SC1090
    . ~/.nix-profile/etc/profile.d/nix.sh
fi

