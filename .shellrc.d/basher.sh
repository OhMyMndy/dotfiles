# shellcheck shell=bash

if [ -d "$HOME/.basher" ]; then
	if ! grep -q "basher" <<<"$PATH"; then
		export PATH="$HOME/.basher/bin:$PATH"
	fi
	if [ -n "$BASH" ] && command -v fzf &>/dev/null; then
		eval "$(basher init - bash)"
	else
		eval "$(basher init - zsh)"
	fi
else
	git clone --depth=1 https://github.com/basherpm/basher.git ~/.basher
fi
