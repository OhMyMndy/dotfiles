# shellcheck shell=bash

if [ -n "$BASH" ] && command -v docker &>/dev/null; then
  . <(docker completion bash)
elif command -v docker &>/dev/null; then
  . <(docker completion zsh)
fi
