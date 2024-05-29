# shellcheck shell=bash
if [ -n "$BASH" ] && command -v fzf &>/dev/null; then
	eval "$(fzf --bash)"
fi