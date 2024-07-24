# shellcheck shell=bash
if [ -n "$container" ]; then
    PS1="$container - ${PS1}"
fi