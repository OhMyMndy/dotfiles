# shellcheck shell=bash
if command -v switcher &>/dev/null; then
	if [ "$shell" = "zsh" ] || [ "$shell" = "bash" ]; then
		# shellcheck disable=SC1090
		source <(switcher init "$shell")
		# shellcheck disable=SC1090
		source <(switch completion "$shell")
	fi
fi
