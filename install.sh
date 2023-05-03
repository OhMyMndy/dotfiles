#!/usr/bin/env bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

source "$DIR/zsh/.sharedrc" || source "$HOME/.sharedrc" 

if [[ "$TERM" = '' ]]; then
    export TERM=xterm
fi


time nix run . switch -- --flake .