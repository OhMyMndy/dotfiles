#!/usr/bin/env bash

set -eu -o functrace

this_command=''
previous_command=''
trap 'previous_command=$this_command; this_command=$BASH_COMMAND' DEBUG
___finish() {
	>&2 echo "Error while executing '$previous_command' in $0, line $1"
	exit $?
}
trap '___finish $LINENO' ERR

___shutdown() {
	exit 99
}
trap "___shutdown" INT TERM

if command -v git &> /dev/null; then
	ROOT_DIR="$(git rev-parse --show-toplevel)/"
fi

# shellcheck source=.functions
source "$ROOT_DIR.functions"