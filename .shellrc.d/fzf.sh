# shellcheck shell=bash
if command -v fzf &>/dev/null; then
	if [ "$shell" = "zsh" ] || [ "$shell" = "bash" ]; then
		eval "$(fzf --"$shell")"
	fi
fi
