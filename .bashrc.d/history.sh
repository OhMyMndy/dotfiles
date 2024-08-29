# shellcheck shell=bash
if [ -n "$BASH" ]; then
    shopt -s histappend
    PROMPT_COMMAND="history -w;$PROMPT_COMMAND"
fi
