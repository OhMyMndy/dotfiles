# shellcheck shell=bash
if [ -n "$BASH" ]; then
    shopt -s histappend
    PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
fi