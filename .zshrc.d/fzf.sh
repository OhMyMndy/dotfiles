# shellcheck shell=bash
if command -v fzf &>/dev/null; then
	eval "$(fzf --zsh)"
fi
