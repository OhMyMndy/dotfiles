# shellcheck shell=bash
if grep -qi Microsoft /proc/version; then PS1="[$WSL_DISTRO_NAME] ${PS1}"; fi