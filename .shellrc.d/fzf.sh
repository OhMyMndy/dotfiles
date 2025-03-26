# shellcheck shell=bash
if [ -n "$BASH" ] && command -v fzf &>/dev/null; then
	eval "$(fzf --bash)"
elif command -v fzf &>/dev/null; then
	eval "$(fzf --zsh)"
fi
