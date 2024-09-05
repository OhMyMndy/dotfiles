# shellcheck shell=bash
if [ -n "$BASH" ]; then
    shopt -s histappend
    export HISTCONTROL=ignoreboth:erasedups
    PROMPT_COMMAND="history -a; history -c; history -r"
fi
