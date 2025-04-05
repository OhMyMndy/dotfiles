#!/usr/bin/env bash

if ! grep -q "krew" <<< "$PATH"; then
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi
