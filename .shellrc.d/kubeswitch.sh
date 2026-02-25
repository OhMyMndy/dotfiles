# shellcheck shell=bash
if [ -n "$BASH" ] && command -v switcher &>/dev/null; then
	# shellcheck disable=SC1090
	source <(switcher init bash)
  # shellcheck disable=SC1090
  source <(switch completion bash)

elif command -v switcher &>/dev/null; then
  	# shellcheck disable=SC1090
	source <(switcher init zsh)
	# shellcheck disable=SC1090
	source <(switch completion zsh)
fi