# shellcheck shell=bash
if command -v docker &>/dev/null; then
  if [ "$shell" = "zsh" ] || [ "$shell" = "bash" ]; then
    . <(docker completion "$shell")
  fi
fi
