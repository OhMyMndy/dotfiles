# shellcheck shell=bash
if [ -n "$BASH" ] && [ -n "$http_proxy" ]; then
    PS1="Proxy: ${PS1}"
fi