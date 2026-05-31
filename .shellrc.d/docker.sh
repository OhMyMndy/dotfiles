# shellcheck shell=bash

if [ -n "$BASH" ] && command -v docker &>/dev/null; then
  . <(docker completion bash)
  if docker compose version &>/dev/null; then
    . <(docker compose completion bash)
  fi
elif command -v docker &>/dev/null; then
  . <(docker completion zsh)
  if docker compose version &>/dev/null; then
    . <(docker compose completion zsh)
  fi
fi
