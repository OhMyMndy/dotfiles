# shellcheck shell=bash
if ! grep -q "arkade" <<< "$PATH"; then
  export PATH=$PATH:$HOME/.arkade/bin/
fi