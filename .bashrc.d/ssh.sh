# shellcheck shell=bash
if [ -n "$SSH_CLIENT" ] && [[ -z "$STARSHIP_SHELL" ]]; then
    PS1="SSH from $(echo "$SSH_CLIENT" | cut -f1 -d' '): $PS1"
fi
