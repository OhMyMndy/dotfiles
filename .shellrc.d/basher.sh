# shellcheck shell=bash

if [ -d "$HOME/.basher" ]; then
	if ! grep -q "basher" <<<"$PATH"; then
		export PATH="$HOME/.basher/bin:$PATH"
	fi
	if command -v fzf &>/dev/null; then
		if [ "$shell" = "zsh" ] || [ "$shell" = "bash" ]; then
			eval "$(basher init - "$shell")"
		fi
	fi
else
	git clone --depth=1 https://github.com/basherpm/basher.git ~/.basher
fi
