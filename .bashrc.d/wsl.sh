# shellcheck shell=bash
if grep -qi Microsoft /proc/version && [[ -z "$STARSHIP_SHELL" ]]; then
    PS1="[$WSL_DISTRO_NAME] ${PS1}";
fi